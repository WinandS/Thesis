import json
import glob


# get input data from file
def open_json_file(filename):
    for filename in glob.glob(filename):
        with open(filename) as data_file:
            data = json.load(data_file)
            return data


# extract signals from input data
def extract_signals(data):
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


# extract all relevant info from json file
def extract_info(filename):
    data = open_json_file(filename)
    return data["name"], data["test"], extract_signals(data)


# print extracted wavedrom signals
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
