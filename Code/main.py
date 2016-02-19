import read_json
import generate_testbench
import json_to_vhdl
import run_vunit
import glob

for filename in glob.glob("json_resources/*.json"):

    # - import wavedrom input, extract signals from raw data and print them
    entity_name, test_name, signals = read_json.extract_info(filename)
    # read_json.print_signals(signals)

    # - read the testbench template
    vhdl_testbench = generate_testbench.read_template()

    # - clean the template
    vhdl_testbench = generate_testbench.clean_testbench_template(vhdl_testbench)

    # - set up uut declaration, port map and signal declaration
    s = filename.find("/")
    e = filename.find(".")
    filename = filename[s+1:e]

    port_declaration, port_map, signal_declarations = json_to_vhdl.generate_vhdl(signals)
    vhdl_testbench = generate_testbench.generate_testbench(vhdl_testbench, entity_name, port_declaration,
                                                           port_map, signal_declarations, filename, test_name)

    # - set up stimulus and checking process
    vhdl_testbench = generate_testbench.set_up_stimulus_process(vhdl_testbench, test_name, signals[1])
    vhdl_testbench = generate_testbench.set_up_check_process(vhdl_testbench, test_name, signals[2])

    # - write changes to vhdl testbench
    generate_testbench.write_output(vhdl_testbench, filename)

    # - open output file
    # generate_testbench.open_output(filename)


# - run vunit on created file(s)
run_vunit.run()
