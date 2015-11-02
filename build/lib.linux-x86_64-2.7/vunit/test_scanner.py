# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2014-2015, Lars Asplund lars.anders.asplund@gmail.com

"""
Functionality to automatically create test suites from a project
"""


import logging
LOGGER = logging.getLogger(__name__)

from os.path import basename, dirname, splitext
import re

from vunit.test_list import TestList
from vunit.test_bench import TestBench
import vunit.ostools as ostools
from vunit.vhdl_parser import remove_comments
from vunit.test_suites import IndependentSimTestCase, SameSimTestSuite
from vunit.test_configuration import create_scope


class TestScanner(object):
    """
    Scans a project for test benches
    """

    def __init__(self, simulator_if, configuration):
        self._simulator_if = simulator_if
        self._cfg = configuration

    def from_project(self, project, entity_filter=None):
        """
        Return a TestList with all test found within the project
        entity_filter -- An optional filter function of entity objects
        """
        test_list = TestList()
        for library in sorted(project.get_libraries(), key=lambda lib: lib.name):
            for entity in sorted(library.get_entities(), key=lambda ent: ent.name):
                if entity_filter is None or entity_filter(entity):
                    self._create_tests_from_entity(test_list, entity)

            for module in sorted(library.get_modules(), key=lambda module: module.name):
                if entity_filter is None or entity_filter(module):
                    self._create_tests_from_module(test_list, module)
        return test_list

    def _create_tests_from_entity(self, test_list, entity):
        """
        Derive test cases from an entity if there is one generic called
        runner_cfg
        """
        for architecture_name in sorted(entity.architecture_names):
            self._create_tests_from_unit(test_list, entity, architecture_name)

    def _create_tests_from_module(self, test_list, entity):
        """
        Derive test cases from an module if there is one generic called
        runner_cfg
        """
        self._create_tests_from_unit(test_list, entity, None, verilog=True)

    def _create_tests_from_unit(self, test_list, entity, architecture_name, verilog=False):
        """
        Derive test cases from an unit
        """
        has_runner_cfg = verilog or ("runner_cfg" in entity.generic_names)
        pragmas, run_strings = self._parse(entity, architecture_name, verilog)
        should_run_in_same_sim = "run_all_in_same_sim" in pragmas

        def create_test_bench(config):
            """
            Helper function to create a test bench
            """
            fail_on_warning = "fail_on_warning" in pragmas
            return self._create_test_bench(entity, architecture_name, config, fail_on_warning, verilog)

        def create_name(config, run_string=None):
            """
            Helper function to create a test name
            """
            return create_test_name(entity, architecture_name, config.name, run_string)

        self._warn_on_individual_configuration(create_scope(entity.library_name, entity.name),
                                               run_strings,
                                               should_run_in_same_sim)

        if len(run_strings) == 0 or not has_runner_cfg:
            scope = create_scope(entity.library_name, entity.name)
            configurations = self._cfg.get_configurations(scope)
            for config in configurations:
                test_list.add_test(
                    IndependentSimTestCase(
                        name=create_name(config),
                        test_case=None,
                        test_bench=create_test_bench(config),
                        has_runner_cfg=has_runner_cfg,
                        post_check_function=config.post_check))
        elif should_run_in_same_sim:
            scope = create_scope(entity.library_name, entity.name)
            configurations = self._cfg.get_configurations(scope)
            for config in configurations:
                test_list.add_suite(
                    SameSimTestSuite(name=create_name(config),
                                     test_cases=run_strings,
                                     test_bench=create_test_bench(config),
                                     post_check_function=config.post_check))
        else:
            for run_string in run_strings:
                scope = create_scope(entity.library_name, entity.name, run_string)
                configurations = self._cfg.get_configurations(scope)
                for config in configurations:
                    test_list.add_test(
                        IndependentSimTestCase(
                            name=create_name(config, run_string),
                            test_case=run_string,
                            test_bench=create_test_bench(config),
                            has_runner_cfg=has_runner_cfg,
                            post_check_function=config.post_check))

    def _create_test_bench(self,  # pylint: disable=too-many-arguments
                           entity, architecture_name, config, fail_on_warning, verilog):
        """
        Helper function to create a test bench given a config
        """
        def add_tb_path_generic(generics):
            """
            Add tb_path generic pointing to directory name of test bench
            """
            name = "tb_path"
            if verilog:
                file_name = entity.file_name
            else:
                file_name = entity.architecture_names[architecture_name]
            new_value = '%s/' % dirname(file_name).replace("\\", "/")
            if (name in generics) and (name in entity.generic_names):
                LOGGER.warning(("The '%s' generic from a configuration of %s of was overwritten, "
                                "old value was '%s', new value is '%s'"),
                               name,
                               create_test_name(entity, architecture_name, config.name),
                               generics["tb_path"],
                               new_value)

            generics["tb_path"] = new_value

        generics = config.sim_config.generics.copy()

        if "tb_path" in entity.generic_names:
            add_tb_path_generic(generics)

        config.sim_config.fail_on_warning = fail_on_warning
        config.sim_config.generics = prune_generics(generics, entity)

        return TestBench(simulator_if=self._simulator_if,
                         library_name=entity.library_name,
                         entity_name=entity.name,
                         architecture_name=architecture_name,
                         sim_config=config.sim_config,
                         has_output_path="output_path" in entity.generic_names)

    def _parse(self, entity, architecture_name, verilog):
        """
        Parse file for run strings and pragmas
        """
        if verilog:
            file_name = entity.file_name
        else:
            file_name = entity.architecture_names[architecture_name]
        code = ostools.read_file(file_name)

        pragmas = self.find_pragmas(code, file_name)

        # @TODO use presence of runner_cfg as tb_filter instead of tb_*
        has_runner_cfg = verilog or ("runner_cfg" in entity.generic_names)

        if has_runner_cfg:
            run_strings = self.find_run_strings(code, file_name, verilog)
        else:
            run_strings = []

        return pragmas, run_strings

    def _warn_on_individual_configuration(self, scope, run_strings, should_run_in_same_sim):
        """
        Warn on individual test configurations
        """
        more_specific = self._cfg.more_specific_configurations(scope)
        self._warn_on_non_existent(more_specific, run_strings)
        if should_run_in_same_sim and len(more_specific) != 0:
            LOGGER.warning("Found %i individual test configurations within \"%s\""
                           " which is not possible with run_all_in_same_sim",
                           len(more_specific),
                           dotjoin(*scope))

    @staticmethod
    def _warn_on_non_existent(more_specific, run_strings):
        """
        Warn on configuration of non existent test
        @TODO since we cannot raise KeyError on .test() in ui
        """
        for specific_scope in sorted(more_specific):
            if not specific_scope[-1] in run_strings:
                LOGGER.warning("Found configuration of non-existent test \"%s\"",
                               dotjoin(*specific_scope))

    _valid_run_string_fmt = r'[A-Za-z0-9_\-\. ]+'
    _re_valid_run_string = re.compile(_valid_run_string_fmt + "$")
    _re_vhdl_run_string = re.compile(r'\s+run\("(.*?)"\)', re.IGNORECASE)
    _re_verilog_run_string = re.compile(r'`TEST_CASE\("(.*?)"\)')

    def find_run_strings(self, code, file_name, verilog):
        """
        Finds all if run("something") strings in file
        """
        if verilog:
            # @TODO verilog
            regexp = self._re_verilog_run_string
        else:
            code = remove_comments(code)
            regexp = self._re_vhdl_run_string

        run_strings = [match.group(1)
                       for match in regexp.finditer(code)]

        unique = set()
        not_unique = set()
        for run_string in run_strings:
            if run_string in unique and run_string not in not_unique:
                # @TODO line number information could be useful
                LOGGER.error('Duplicate test case "%s" in %s',
                             run_string, file_name)
                not_unique.add(run_string)
            unique.add(run_string)

        if len(not_unique) > 0:
            raise TestScannerError

        for run_string in run_strings:
            if self._re_valid_run_string.match(run_string) is None:
                LOGGER.warning('Test name "%s" does not match %s in %s',
                               run_string, self._valid_run_string_fmt, file_name)

        return run_strings

    _re_pragma = re.compile(r'vunit_pragma\s+([a-zA-Z0-9_]+)', re.IGNORECASE)
    _valid_pragmas = ["run_all_in_same_sim", "fail_on_warning"]

    def find_pragmas(self, code, file_name):
        """
        Return a list of all vunit pragmas parsed from the code

        @TODO only look inside comments
        """
        pragmas = []
        for match in self._re_pragma.finditer(code):
            pragma = match.group(1)
            if pragma not in self._valid_pragmas:
                LOGGER.warning("Invalid pragma '%s' in %s",
                               pragma,
                               file_name)
            pragmas.append(pragma)
        return pragmas


def tb_filter(entity):
    """ Filter entities with file name tb_* and entity_name tb_* """
    file_ok = basename(entity.file_name).startswith("tb_") or splitext(basename(entity.file_name))[0].endswith("_tb")
    entity_ok = entity.name.startswith("tb_") or entity.name.endswith("_tb")

    if file_ok and entity_ok:
        return True
    return False


class TestScannerError(Exception):
    pass


def dotjoin(*args):
    """ string arguments joined by '.' unless empty string or None"""
    return ".".join(arg for arg in args if arg not in ("", None))


def prune_generics(generics, entity):
    """
    Keep only generics with name in entity.generic_names
    """
    generics = generics.copy()
    for gname in list(generics.keys()):
        if gname not in entity.generic_names:
            LOGGER.warning(
                "Generic '%s' set to value '%s' not found in entity '%s.%s'. Possible values are [%s]",
                gname, generics[gname],
                entity.library_name, entity.name,
                ", ".join('%s' % name for name in entity.generic_names))
            del generics[gname]
    return generics


def create_test_name(entity, architecture_name, config_name, test_name=None):
    if (architecture_name is None) or (len(entity.architecture_names) > 1):
        return dotjoin(entity.library_name, entity.name, architecture_name, config_name, test_name)
    else:
        return dotjoin(entity.library_name, entity.name, config_name, test_name)
