import read_json
import generate_testbench
import json_to_vhdl

# - import wavedrom input, extract signals from raw data and print them
testfile = read_json.open_json_file("json_resources/testfile.json")
signals = read_json.extract_signals(testfile)
# read_json.print_signals(signals)


# - read the testbench template
vhdl_testbench = generate_testbench.read_template()


# - clean the template
vhdl_testbench = generate_testbench.clean_testbench_template(vhdl_testbench)


# - translate a signal to vhdl and add it to the testbench
signal_declaration = json_to_vhdl.translate(signals[0])
vhdl_testbench = generate_testbench.add_signal_declaration(vhdl_testbench, signal_declaration)


# - write changes to vhdl testbench
generate_testbench.write_output(vhdl_testbench)

# - open output file
generate_testbench.open_output()
