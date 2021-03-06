import os
import re
from os.path import join

import sys

testbench_template = join("vhdl_files", ".template_TB.vhd")
output_path = join("vhdl_files", "test", "tb_")
log_dir = ""    # set this in main


# <editor-fold desc="Read testbench template and write result testbench">
def read_template():
    with open(testbench_template, 'r') as template_file:
        template = template_file.read()
    template_file.close()
    return template


def write_output(data, filename):
    complete_filename = output_path + filename + ".vhd"
    with open(complete_filename, 'w') as test_file:
        test_file.write(data)
    test_file.close()
# </editor-fold>


# <editor-fold desc="open testbench in sigasi studio (debugging)">
def open_output(filename):
    sigasi_path = ""
    if sys.platform == 'darwin':
        sigasi_path = join("opt", "sigasi", "sigasi")
    elif sys.platform == 'linux2':
        sigasi_path = join("opt", "sigasi", "sigasi")
    elif sys.platform == 'win32':
        sigasi_path = join("sigasi")
    os.system(sigasi_path + output_path + filename + ".vhd")
    # os.system("gedit " + output_path + filename + ".vhd")
# </editor-fold>


def clean_testbench_template(template):
    # <editor-fold desc="Clean comments from template">
    pattern = re.compile('--/')
    # TODO: make this better
    for x in range(0, 15):
        for match in re.finditer(pattern, template):
            s = match.start()
            pattern2 = re.compile('/--')
            for match2 in re.finditer(pattern2, template):
                e = match2.end()
                break       # don't remember why I did this, don't think it is necessary anymore
            template = template.replace(template[s:e + 1], "")
            break
    return template
    # </editor-fold>


def set_up_uut(testbench, entity_name, port_declaration, port_map, filename):
    # <editor-fold desc="Add UUT related building blocks to the template">
    testbench = testbench.replace("entity_name", filename)
    testbench = testbench.replace("COMPONENT uut", "COMPONENT " + entity_name + '\n')
    testbench = testbench.replace("UUT PORT MAP", entity_name + " PORT MAP")

    testbench = testbench.replace("PORT();", port_declaration + "\n")
    testbench = testbench.replace("PORT MAP();", port_map + "\n")

    return testbench
    # </editor-fold>


def set_clock_cycles_constant(testbench, first_in_signal):
    # <editor-fold desc="Declare clock cycles constant">
    # clock cycle constant is derived from first input signal. It is equal to its length.
    # TODO: fix this cheating. If the design is combinatorical, clcok_cycles should be 1, but it is changed to 2,
    # TODO: because there can be no array of length 1.
    length = len(first_in_signal["wave"])

    try:
        period = int(first_in_signal["period"])
    except KeyError:
        period = 1

    if length == 1:
        length = 2

    find = "--# Clock Cycles"
    replace = find + "\n" + "constant clock_cycles : integer := " + str(length * period) + ";"

    return testbench.replace(find, replace)
    # </editor-fold>


# set up everything related to timing
def set_up_waiting_necessities(testbench, json_loop_times, relative_period):
    # <editor-fold desc="If the design has loops, add the necessary building blocks">
    find = "--# Wait Variables"
    replace = find + "\n" + " variable wait_array_index : integer := 0;" + \
              "variable wait_variable : integer := wait_array(wait_array_index);"
    testbench = testbench.replace(find, replace)

    find = "--# Extra Code For Waiting"
    replace = "if sig_clk_values(2 * n) = '-' and wait_variable > 0 then " + "\n" + \
              "while wait_variable > 0 loop" + "\n" + \
              "v := n mod (relative_period);" + "\n" + \
              "while (v - (n mod (relative_period)) < relative_period) loop" + "\n" + \
              "--# Loop Stimulus rising edge" + "\n" + \
              "--# Loop Stimulus falling edge" + "\n" + \
              "--# test checking" + "\n" + \
              "v := v + 1;" + "\n" + \
              "end loop;" + "\n" + \
              "wait_variable := wait_variable - 1;" + "\n" + \
              "end loop;" + "\n" + \
              "n := n + relative_period;" + "\n" + \
              "wait_array_index := wait_array_index + 1;" + "\n" + \
              "wait_variable    := wait_array(wait_array_index);" + "\n" + \
              "else"
    testbench = testbench.replace(find, replace)

    find = "--# Extra End If For waiting"
    replace = "end if;"
    testbench = testbench.replace(find, replace)

    find = "--# Extra Code For Waiting"
    replace = "if sig_clk_values(2 * n) = '-' and wait_variable > 0 then " + "\n" + \
              "while wait_variable > 0 loop" + "\n" + \
              "v := n mod (2*relative_period);" + "\n" + \
              "while (v - (n mod (2 * relative_period)) < 2*relative_period) loop"
    testbench = testbench.replace(find, replace)

    find = "--# Wait Times"
    replace = find + "\n" + "constant amount_of_waits : integer := " + str(len(json_loop_times)) + ";"
    testbench = testbench.replace(find, replace)

    find = "--# Relative Period"
    replace = find + "\n" + "constant relative_period : integer :=  " + str(relative_period) + ";"
    testbench = testbench.replace(find, replace)

    find = "--# Helper Types"
    replace = find + "\n" + "type wait_integer_array is array (0 to amount_of_waits) of integer;"
    testbench = testbench.replace(find, replace)

    find = "--# Constants"
    wait_array = ""
    for element in json_loop_times:
        wait_array += ", " + element
    wait_array += ", 0"
    replace = find + "\n" + "constant wait_array : wait_integer_array := (" + wait_array[2:] + ");"
    return testbench.replace(find, replace)
    # </editor-fold>


def set_up_signal_value_constants(testbench, signal_values):
    # <editor-fold desc="Declare all value arrays">
    constants_declaration = ""
    for signal_value in signal_values:
        constants_declaration += signal_value + "\n"
    find = "--# Constants"
    constants_declaration = find + "\n" + constants_declaration
    return testbench.replace(find, constants_declaration)
    # </editor-fold>


def set_up_signals(testbench, signal_declarations):
    # <editor-fold desc="Declare all signals">
    signal_types = ["Clock", "Input", "Output"]
    i = 0
    for type in signal_declarations:
        if len(type) > 0:
            for signal_decl in type:
                find = "--# " + signal_types[i] + " Signals"
                replace = find + "\n" + signal_decl
                testbench = testbench.replace(find, replace)
        i += 1
    return testbench
    # </editor-fold>


def set_up_stimulus_process(testbench, test_name, input_signals):
    # <editor-fold desc="Create signal driving code">
    testbench = testbench.replace("test_name", test_name)  # set test name
    is_clocked = False
    if len(input_signals[0]) > 0:
        for signal in input_signals[0]:
            if len(signal) > 0:
                is_clocked = True

    rising_stimulus = ""
    loop_rising_stimulus = ""
    falling_stimulus = ""
    loop_falling_stimulus = ""
    i = 0
    for signal_type in input_signals:  # clk and in type signals
        if len(signal_type) > 0:
            for signal in signal_type:
                if len(signal) > 0:
                    if is_clocked and i == 0:  # if the signal is a clock signal
                        rising_stimulus += "sig_" + signal["name"] + " <= sig_" + signal["name"] + "_values(2*n);\n"
                        loop_rising_stimulus += "sig_" + signal["name"] + " <= sig_" + signal["name"] + "_values(2*v);\n"
                        falling_stimulus += "sig_" + signal["name"] + " <= sig_" + signal["name"] + "_values(2*n+1);\n"
                        loop_falling_stimulus += "sig_" + signal["name"] + " <= sig_" + signal["name"] + "_values(2*v+1);\n"
                    else:
                        assignment = "sig_" + signal["name"] + " <= sig_" + signal["name"] + "_values(n);\n"
                        rising_stimulus += assignment
                        loop_rising_stimulus += assignment
                    i += 1
    if not is_clocked:
        falling_stimulus += "wait for 10 ns;"
    find_rising = "--# Stimulus rising edge"
    loop_find_rising = "--# Loop Stimulus rising edge"
    find_falling = "--# Stimulus falling edge"
    loop_find_falling = "--# Loop Stimulus falling edge"

    testbench = testbench.replace(find_rising, rising_stimulus)
    testbench = testbench.replace(loop_find_rising, loop_rising_stimulus)
    testbench = testbench.replace(find_falling, falling_stimulus)
    return testbench.replace(loop_find_falling, loop_falling_stimulus)
    # </editor-fold>


def set_up_check_process(testbench, output_signals):
    # <editor-fold desc="Create signal checking code">
    checking = ""

    for signal in output_signals:
        signal_name = signal["name"].strip()
        expected_value = "sig_" + signal_name + "_values(n)"
        signal_to_check = "sig_" + signal_name
        signal_type = signal["type"]
        try:
            signal["vector_size"]
            checking += "\n if " + expected_value + "(0) /= 'X' then" + "\n" + \
                "check(" + signal_to_check + " = " + expected_value + ", " \
                "\"Woops\");" + "\n" + \
                "if " + signal_to_check + " = " + expected_value + " then" + "\n" + \
                "error_number := error_number + 1;" + "\n" + \
                "end if;" + "\n" + \
                "end if;" + "-- Do some check for a vector \n"
        except KeyError:
            checking += "\n if " + expected_value + " /= 'X' then" + "\n" + \
                        "check(warning_logger,  " + signal_to_check + " = " + expected_value + \
                        ", integer'image(error_number) & \"," + \
                        signal_name + ",\" & " + signal_type + "'image(" + expected_value + ") & " \
                        "\",\" &  " + signal_type + "'image(" + signal_to_check + \
                        ") & \",\" & integer'image(n) " \
                        ", line_num => error_number);" + "\n" + \
                        "check(" + signal_to_check + " = " + expected_value + ", " + \
                        "integer'image(error_number) & \". This check failed. Expected " + signal_to_check + " = " + \
                        " \" & " + signal_type + "'image(" + expected_value + ") & \", got " + signal_to_check + " = " + \
                        " \" & " + signal_type + "'image(" + signal_to_check + \
                        ") & \" at n = \" & integer'image(n) & \".\" );" + "\n" + \
                        "if " + signal_to_check + " /= " + expected_value + " then" + "\n" + \
                        "error_number := error_number + 1;" + "\n" + \
                        "end if;" + "\n" + \
                        "end if;" + "\n"

    find = "--# test checking"
    return testbench.replace(find, checking)
    # </editor-fold>


def set_up_timing(testbench, signals):
    # <editor-fold desc="Add all timing related elements to vhdl file">
    # - add clock period
    find = "--# Constants"
    replace = ""
    clock_period = 20.0
    for signal in signals[0]:
        if len(signal) > 0:

            try:
                relative_period = int(signal["period"])
            except KeyError:
                relative_period = 1

            try:
                clock_period = float(signal["clock_period"]) / relative_period
            except KeyError:
                clock_period /= relative_period

            replace += find + "\n" + "constant internal_clock_period : time := " + str(clock_period) + " ns;"
            # replace += find + "\n" + "constant internal_clock_period : time := " + signal["clock_period"] + ";"
    testbench = testbench.replace(find, replace + "\n")

    # - add EndOfSimulation signal
    find = "--# Timing Signals"
    replace = find + "\n" + "signal EndOfSimulation : std_logic := '0';"
    replace += "signal internal_clock : std_logic := '1';"
    testbench = testbench.replace(find, replace + "\n")

    # - add simulation step signal
    find = "--# Simulation Signals"
    replace = find + "\n" + "signal sig_n : integer := 0;"
    testbench = testbench.replace(find, replace + "\n")

    # - add simulation step signal
    find = "--# sig_n driver"
    replace = "sig_n <= n;"
    testbench = testbench.replace(find, replace + "\n")

    # - end simulation
    find = "--# set endofsimulation"
    replace = "EndOFSimulation <= '1';"
    testbench = testbench.replace(find, replace + "\n")

    # - add internal clock driver process
    find = "--# Clock driver"
    replace = "Clk_process : process" + "\n" \
              + "begin" + "\n" \
              + "if (EndOfSimulation = '0') then" + "\n" \
              + "internal_clock <= '1';" + "\n" \
              + "wait for internal_clock_period / 2;" + "\n" \
              + "internal_clock <= '0';" + "\n" \
              + "wait for internal_clock_period - internal_clock_period / 2;" + "\n" \
              + "end if;" + "\n" \
              + "end process;" + "\n"
    testbench = testbench.replace(find, replace)

    # - add wait statements for rising and falling edge
    find_rising = "--# Stimulus rising edge"
    loop_find_rising = "--# Loop Stimulus rising edge"
    find_falling = "--# Stimulus falling edge"
    loop_find_falling = "--# Loop Stimulus falling edge"
    replace_rising = "wait until rising_edge(internal_clock);" + "\n" + find_rising
    loop_replace_rising = "wait until rising_edge(internal_clock);" + "\n" + loop_find_rising
    replace_falling = "wait until falling_edge(internal_clock);" + "\n" + find_falling
    loop_replace_falling = "wait until falling_edge(internal_clock);" + "\n" + loop_find_falling
    testbench = testbench.replace(find_rising, replace_rising + "\n")
    testbench = testbench.replace(loop_find_rising, loop_replace_rising + "\n")
    testbench = testbench.replace(find_falling, replace_falling + "\n")
    testbench = testbench.replace(loop_find_falling, loop_replace_falling + "\n")

    # - add loop
    find_start = "--# Loop start"
    find_end = "--# Loop end"
    replace_start = "while (n <= clock_cycles - 1) loop" + "\n"
    replace_end = "end loop;" + "\n"
    testbench = testbench.replace(find_start, replace_start + "\n")
    testbench = testbench.replace(find_end, replace_end + "\n")

    return testbench
    # </editor-fold>


def declare_helper_types(testbench, signals):
    # <editor-fold desc="Generate helper types">
    types = [[], []]
    i = 0
    for signal_type in signals:  # here type is clock, input or output
        if len(signal_type) > 0:
            for signal in signal_type:
                if len(signal) > 0:
                    if signal["type"] not in types[i]:  # here type is vhdl logic type
                        types[i].append(signal["type"])  # clock signals will be handled differently and are kept apart
        if i < 1:  # input and output signals don't need to be separated
            i += 1

    # - type declarations
    find = "--# Helper Types"
    replace_type = ""
    for logic_type in types[0]:
        replace_type += "type clk_" + str(logic_type) + "_array is array (0 to 2*clock_cycles - 1) of " \
                        + str(logic_type) + ";" + "\n"
    for logic_type in types[1]:
        replace_type += "type " + str(logic_type) + "_array is array (0 to clock_cycles - 1) of " \
                        + str(logic_type) + ";" + "\n"

    return testbench.replace(find, find + "\n" + replace_type)
    # </editor-fold>


def generate_testbench(testbench, entity_name, port_declaration, port_map, signal_declarations, signal_values,
                       filename, test_name, signals):
    # <editor-fold desc="Place all testbench building blocks in testbench template and save result">

    # set output directory
    find = "output_directory"
    replace = log_dir
    testbench = testbench.replace(find, replace)

    # set up everything involving uut
    testbench = set_up_uut(testbench, entity_name, port_declaration, port_map, filename)

    # - declare clock cycles constant
    first_in_signal = signals[1][0]
    testbench = set_clock_cycles_constant(testbench, first_in_signal)

    # - declare everything involving waits if necessary
    try:
        json_loop_times = signals[0][0]["loop_times"]
    except:
        json_loop_times = []
    try:
        relative_period = signals[0][0]["period"]
    except:
        relative_period = 1

    if len(json_loop_times) > 0:
        testbench = set_up_waiting_necessities(testbench, json_loop_times, relative_period)

    # - declare sig_values constants
    testbench = declare_helper_types(testbench, signals)
    testbench = set_up_signal_value_constants(testbench, signal_values)

    # - check whether or not there is a clock signal involved
    if len(signals[0]) > 0:
        for signal in signals[0]:
            if len(signal) > 0:
                # - set up all timing related testbench elements
                testbench = set_up_timing(testbench, signals)
                break

    # - declare all signals
    testbench = set_up_signals(testbench, signal_declarations)

    # - set up stimulus and checking process
    testbench = set_up_stimulus_process(testbench, test_name, signals[0:2])
    testbench = set_up_check_process(testbench, signals[2])
    return testbench
    # </editor-fold>
