# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2014-2015, Lars Asplund lars.anders.asplund@gmail.com

from os.path import join, dirname
from vunit import VUnit


def run():
    ui = VUnit.from_argv()
    ui.add_osvvm()

    src_path = join(dirname(__file__), "vhdl_files")

    src_lib = ui.add_library("src_lib")
    src_lib.add_source_files(join(src_path, "src", "*.vhd"))

    test_lib = ui.add_library("test_lib")
    test_lib.add_source_files(join(src_path, "test", "*.vhd"))

    ui.main()


