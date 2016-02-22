import os
import re

testbench_template = 'vhdl_files/template_TB.vhd'
# file_to_test = 'vhdl_files/src/file_to_test.vhd'
output_path = 'vhdl_files/test/tb_'


def read_template():
    with open(testbench_template, 'r') as template_file:
            template = template_file.read()
    template_file.close()
    return template


# def read_file_to_test():
#     with open(file_to_test, 'r') as template_file:
#             template = template_file.read()
#     template_file.close()
#     return template


def write_output(data, filename):
    complete_filename = output_path + filename + ".vhd"
    with open(complete_filename, 'w') as template_file:
            template_file.write(data)
    template_file.close()


def open_output(filename):
    os.system("/opt/sigasi/sigasi " + output_path + filename + ".vhd")
    # os.system("gedit " + output_file)


def clean_testbench_template(template):
    pattern = re.compile('--/')
    # TODO: make this better
    for x in range(0,15):
        for match in re.finditer(pattern, template):
            s = match.start()
            pattern2 = re.compile('/--')
            for match2 in re.finditer(pattern2, template):
                e = match2.end()
                break
            template = template.replace(template[s:e+1], "")
            break
    return template


def set_up_uut(testbench, entity_name, port_declaration, port_map, filename):
    testbench = testbench.replace("entity_name", filename)
    testbench = testbench.replace("COMPONENT uut", "COMPONENT " + entity_name + '\n')
    testbench = testbench.replace("UUT PORT MAP", entity_name + " PORT MAP")

    testbench = testbench.replace("PORT();", port_declaration + "\n")
    testbench = testbench.replace("PORT MAP();", port_map + "\n")

    return testbench


def set_up_signals(testbench, signal_declarations):
    signal_types = ["Clock", "Input", "Output"]
    i = 0
    for type in signal_declarations:
        if len(type) > 0:
            for signal_decl in type:
                find = "--# " + signal_types[i] + " Signals"
                replace = "--# " + signal_types[i] + " Signals \n" + signal_decl
                testbench = testbench.replace(find, replace)
        i += 1
    return testbench


def set_up_stimulus_process(testbench, test_name, input_signals):
    stimulus = ""
    for signal in input_signals:
        wave = signal["wave"]
        stimulus += "sig_" + signal["name"] + " <= '" + wave[0] + "';\n"
    # find = "--# " + test_name + "stimulus"
    find = "--# test stimulus"
    return testbench.replace(find, stimulus)


def set_up_check_process(testbench, test_name, output_signals):
    checking = ""
    for signal in output_signals:
        wave = signal["wave"]
        checking += "check( sig_" + signal["name"] + " = '" + wave[0] + "', \" Expected sig_" + signal["name"] + " = '" \
                    + wave[0]+ "' at this point\");"
    # find = "--# " + test_name + "checking"
    find = "--# test checking"
    return testbench.replace(find, checking)


def generate_testbench(testbench, entity_name, port_declaration, port_map, signal_declarations, filename, test_name):
    testbench = testbench.replace("test_name", test_name)
    testbench = set_up_uut(testbench, entity_name, port_declaration, port_map, filename)
    return set_up_signals(testbench, signal_declarations)
