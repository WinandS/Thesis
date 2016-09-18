import json
import glob

#<editor-fold desc="Open and save JSON files# ">

# get input data from file
def open_json_file(filename):
    for filename in glob.glob(filename):
        with open(filename, 'r') as data_file:
            data = json.load(data_file)
            return data


# write json data to file
def save_json_file(data, filename, output_directory):
    full_filename = output_directory + filename
    with open(full_filename, 'w+') as data_file:
        # strdata = json.dumps(data, indent=4, )
        # parsed = json.loads(strdata)
        json.dump(data, data_file, indent=4, sort_keys=True)
# </editor-fold>


def extract_signals(data):
    # <editor-fold desc="extract signals from waveJSON data">
    clk_signal = []
    input_signals = []
    output_signals = []

    for signal in data["signal"]:
        if len(signal) is not 0:

            if signal[0] == "CLK":
                clk_signal = signal[1]

            elif signal[0] == "IN":
                for j in range(1, len(signal)):
                    input_signals.append(signal[j])

            elif signal[0] == "OUT":
                for j in range(1, len(signal)):
                    output_signals.append(signal[j])

    return [[clk_signal], input_signals, output_signals]
    # </editor-fold>


def extract_info(filename):
    # <editor-fold desc="extract relevant info from waveJSON data">
    data = open_json_file(filename)
    return data["name"], data["test"], data["description"], extract_signals(data)
    # </editor-fold>

# <editor-fold desc="print extracted wavedrom signals (for debugging)">
def print_signals(signals):

    signal_types = ["CLK", "IN", "OUT"]
    i = 0
    for signal_type in signals: # there's three types of signals: CLK, IN and OUT.
        if len(signal_type) > 0:
            print "----------------------------------------------------------------------"
            print "-----------------------           " + signal_types[i] + "             --------------------"
            print "----------------------------------------------------------------------"
            for signal in signal_type:
                print "-------------", signal["name"], "---------------"
                for element in signal:
                    print element, " : ", signal[element]
        i += 1
# </editor-fold>
