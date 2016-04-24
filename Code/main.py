import read_json
import generate_testbench
import json_to_vhdl
import run_vunit
import glob

for filename in glob.glob("json_resources/*.json"):

    # - import wavedrom input, extract signals from raw data and print them
    entity_name, test_name, test_description, signals = read_json.extract_info(filename)
    # read_json.print_signals(signals)

    # - read the testbench template
    vhdl_testbench = generate_testbench.read_template()

    # - clean the template
    vhdl_testbench = generate_testbench.clean_testbench_template(vhdl_testbench)

    # - add header
    vhdl_testbench = "-- ---------------------------------------------------" + "\n" + \
                     "-- Author: " + "\n" + \
                     "-- Test name: " + test_name + "\n" + \
                     "-- Test description: " + test_description + "\n" + \
                     "-- ---------------------------------------------------" + "\n" + \
                     vhdl_testbench

    # - set up uut declaration, port map and signal declaration
    s = filename.find("/")
    e = filename.find(".")
    filename = filename[s+1:e]

    port_declaration, port_map, signal_declarations, signal_values = json_to_vhdl.generate_vhdl(signals)
    vhdl_testbench = generate_testbench.generate_testbench(vhdl_testbench, entity_name, port_declaration,
                                                           port_map, signal_declarations, signal_values, filename,
                                                           test_name, signals)

    # - write changes to vhdl testbench
    generate_testbench.write_output(vhdl_testbench, filename)

    # - open output file
    # generate_testbench.open_output(filename)

# - run vunit on created file(s)
run_vunit.run()
