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
    signals = []
    for i in range(0,len(data["signal"])):
        if len(data["signal"][i]) is not 0:
            # signals.append([data["signal"][i]["name"], data["signal"][i]["wave"]])
            signals.append(data["signal"][i])
    return signals


# print extracted wavedrom signals
def print_signals(signals):
    length = len(signals)
    for i in range(0, length):
        print signals[i]["name"], " : ", signals[i]["wave"]