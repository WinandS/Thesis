import json
import glob


# get input data from file
def open_json_file(name):
    for filename in glob.glob(name):
        with open(filename) as data_file:
            data = json.load(data_file)
            return data


# extract signals from input data
def extract_signals(data):
    clk_signal = []
    input_signals = []
    output_signals = []
    for i in range(0,len(data["signal"])):
        if len(data["signal"][i]) is not 0:
            signal = data["signal"][i]

            if signal[0] == "CLK":
                clk_signal = signal[1]

            elif signal[0] == "IN":
                for j in range(1, len(signal)):
                    input_signals.append(signal[j])

            elif signal[0] == "OUT":
                for j in range(1, len(signal)):
                    output_signals.append(signal[j])

    return [[clk_signal], input_signals, output_signals]


# print extracted wavedrom signals
def print_signals(signals):
    for j in range(0, len(signals)):
        for i in range(0, len(signals[j])):
            print "-------------", signals[j][0]["name"], "---------------"
            for element in signals[j][0]:
                print element, " : ", signals[j][0][element]
            print