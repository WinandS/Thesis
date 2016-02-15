import read_json
import generate_testbench
import json_to_vhdl

# - import wavedrom input, extract signals from raw data and print them
testfile = read_json.open_json_file("json_resources/andgate.json")
signals = read_json.extract_signals(testfile)
# read_json.print_signals(signals)


# - read the testbench template
vhdl_testbench = generate_testbench.read_template()


# - clean the template
vhdl_testbench = generate_testbench.clean_testbench_template(vhdl_testbench)


# - translate a signal to vhdl and add it to the testbench
# for j in range(0, len(signals[0])):
#     clk_declaration = json_to_vhdl.translate(signals[0][j])
#     vhdl_testbench = generate_testbench.add_clock_signal_declaration(vhdl_testbench, clk_declaration)
#
# for j in range(0, len(signals[1])):
#     input_declaration = json_to_vhdl.translate(signals[1][j])
#     vhdl_testbench = generate_testbench.add_input_signal_declaration(vhdl_testbench, input_declaration)
#
# for j in range(0, len(signals[2])):
#     output_declaration = json_to_vhdl.translate(signals[2][j])
#     vhdl_testbench = generate_testbench.add_output_signal_declaration(vhdl_testbench, output_declaration)

vhdl_testbench = generate_testbench.set_up_uut(vhdl_testbench)

# - write changes to vhdl testbench
generate_testbench.write_output(vhdl_testbench)

# - open output file
generate_testbench.open_output()
