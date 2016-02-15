import os
import re

testbench_template = 'template_TB.vhd'
output_file = 'testbench_out.vhd'

def read_template():
    with open(testbench_template, 'r') as template_file:
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
    pattern = re.compile('--/')  # a pattern for a number
    print pattern
    # TODO: make this better
    for x in range(0,15):
        for match in re.finditer(pattern, template):
            s = match.start()
            pattern2 = re.compile('/--')  # a pattern for a number
            for match2 in re.finditer(pattern2, template):
                e = match2.end()
                break
            print "match found!"
            print template[s:e]
            # template[s:e+1].rstrip()
            # template = template.replace(template[s:e],template[s:e+1].rstrip())
            template = template.replace(template[s:e],"")
            break
    return template


def add_signal_declaration(template, signal_decl):
    return template.replace("--# Signals", "--# Signals \n" + signal_decl)
