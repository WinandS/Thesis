import os
import re

testbench_template = 'template_TB.vhd'
file_to_test = 'file_to_test.vhd'
output_file = 'testbench_out.vhd'

def read_template():
    with open(testbench_template, 'r') as template_file:
            template = template_file.read()
    template_file.close()
    return template


def read_file_to_test():
    with open(file_to_test, 'r') as template_file:
            template = template_file.read()
    template_file.close()
    return template


def write_output(data):
    with open(output_file, 'w') as template_file:
            template_file.write(data)
    template_file.close()


def open_output():
    os.system("gedit " + output_file)


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
            # print "match found!"
            # print template[s:e]
            template = template.replace(template[s:e+1], "")
            break
    return template


def set_up_uut(testbench):
    ftt = read_file_to_test()
    s = ftt.find("entity") + len("entity")
    e = ftt.find("is", s)
    name = ftt[s:e]
    testbench = testbench.replace("COMPONENT uut", "COMPONENT " + name + '\n')

    testbench = testbench.replace("UUT PORT MAP", name + "PORT MAP")

    rep = ftt[ftt.find("port(")+len("port("):ftt.find(");")+2]
    testbench = testbench.replace("PORT();", "PORT(" +rep + '\n')

    return testbench

def get_all_ports_from_vhdl(port_list):
    for i in range(0, len(port_list)):
        a = port_list[i]
#     TODO: get all the ports and directions from the port list


def add_clock_signal_declaration(template, signal_decl):
    return template.replace("--# Clock Signal", "--# Clock Signal \n" + signal_decl)


def add_input_signal_declaration(template, signal_decl):
    return template.replace("--# Input Signals", "--# Input Signals \n" + signal_decl)


def add_output_signal_declaration(template, signal_decl):
    return template.replace("--# Output Signals", "--# Output Signals \n" + signal_decl)
