import lib.read_json as read_json
import lib.generate_testbench as generate_testbench
import lib.json_to_vhdl as json_to_vhdl
import lib.compare_wave_traces as compare_wave_traces
import run_vunit
import glob
import os
import subprocess
from Tkinter import *

# relative directory for saving simulation logs.
# Not for users to see.
log_dir = generate_testbench.log_dir = ".warning_log"
testbench_dir = "vhdl_files/test"

# relative directory for result files. This is the user output
result_dir = "result"

# print generate_testbench.log_dir


class Window(Frame):

    def __init__(self, master=None):
        Frame.__init__(self, master)
        self.master = master
        self.init_window()

    def init_window(self):

        # changing the title of our master widget
        self.master.title("What do you want to do?")

        # allowing the widget to take the full space of the root window
        self.pack(fill=BOTH, expand=1)

        # creating a button instance
        # textfield = Label(self, text="Click something")
        # testbenchButton = Button(self, text="Create testbenches and run simulation")
        inputButton = Button(self, text="Open input folder", command=open_input)
        outputButton = Button(self, text="Open output folder", command=open_output)
        srcButton = Button(self, text="Open src folder", command=open_src)
        runButton = Button(self, text="Run simulation", command=run_all)
        # processButton = Button(self, text="Process result", command=process_simulation_result)

        # placing the button on my window
        # textfield.place(x=75, y=50)
        inputButton.place(x=10, y=20)
        srcButton.place(x=180, y=20)
        outputButton.place(x=350, y=20)
        runButton.place(x=180, y=80)
        # processButton.place(x=75, y=200)


def init():
    root = Tk()
    root.geometry("500x120")
    app = Window(root)
    root.mainloop()


def open_input():
    output = os.path.join(os.path.dirname(__file__), "json_resources")
    openFolder(output)


def open_src():
    output = os.path.join(os.path.dirname(__file__), "vhdl_files")
    output = os.path.join(output, "src")
    openFolder(output)


def open_output():
    output = os.path.join(os.path.dirname(__file__), "result")
    openFolder(output)

if sys.platform == 'darwin':
    def openFolder(path):
        subprocess.check_call(['open', '--', path])
elif sys.platform == 'linux2':
    def openFolder(path):
        subprocess.check_call(['nautilus', '--', path])
elif sys.platform == 'win32':
    def openFolder(path):
        subprocess.check_call(['explorer', path])


def run_all():
    # create_and_simulate_tests()
    try:
        create_and_simulate_tests()
        what_to_print = "\n" + "Done."  + "\n"
    except:
        what_to_print = "\n" + "Oh shit, some test failed." + "\n" + "That's okay though, I won't tell anyone." + "\n"
    process_simulation_result()
    print what_to_print


def create_and_simulate_tests():
    # if os.path.exists(log_dir):
    #     for filename in glob.glob(log_dir + "/*"):
    #         os.remove(log_dir)
    #     os.removedirs(log_dir)
    if not os.path.exists(testbench_dir):
        os.makedirs(testbench_dir)
    else:
        for filename in glob.glob(testbench_dir + "/*"):
            os.remove(filename)

    for filename in glob.glob("json_resources/*.json"):

        # - import wavedrom input, extract signals from raw data
        entity_name, test_name, test_description, signals = read_json.extract_info(filename)

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
        filename = filename[s + 1:e]

        port_declaration, port_map, signal_declarations, signal_values = json_to_vhdl.generate_vhdl(signals)
        vhdl_testbench = generate_testbench.generate_testbench(vhdl_testbench, entity_name, port_declaration,
                                                               port_map, signal_declarations, signal_values, filename,
                                                               test_name, signals)

        # - write changes to vhdl testbench
        generate_testbench.write_output(vhdl_testbench, filename)

        # - open output file
        # generate_testbench.open_output(filename)

    # # - create or clear log output directory
    if not os.path.exists(generate_testbench.log_dir):
        os.makedirs(generate_testbench.log_dir)
    else:
        for filename in glob.glob(generate_testbench.log_dir + "/*"):
            # print filename
            os.remove(filename)
    # - run vunit on created file(s)
    run_vunit.run()


def process_simulation_result():
    # - create/clear result directory

    if not os.path.exists(result_dir):
        os.makedirs(result_dir)
    else:
        for filename in glob.glob(result_dir + "/*"):
            os.remove(filename)

    # - create wave trace comparison files
    compare_wave_traces.create_comparison_files(generate_testbench.log_dir, result_dir)


# - run gui
init()
