import csv
import glob
import read_json
import copy

json_resource_path = "json_resources"


def create_comparison_files(log_dir, result_dir):
    # <editor-fold desc="Create result file for wave trace analysis. WaveJSON file to use with WaveDrom.">
    for filename in glob.glob(log_dir + "/*result.csv"):
        result_filename, warning_messages, warning_logs, json_data = get_info(filename)
        # print result_filename
        if not len(warning_logs):       # test succeeded
            # print result_filename
            json_data["head"] = {"text": ['tspan', {"class":'success h3'}, 'Simulation success '], "tick": 0}
            read_json.save_json_file(json_data, result_filename, result_dir)
        else:
            e = result_filename.find(".json")
            f = open(result_dir + result_filename[:e] + '.txt', 'w+')
            for i in range(0, len(warning_messages)):
                message = warning_messages[i]
                log = warning_logs[i]

                f.write("W" + log[0] + ": " + message[0] + ", " + message[1] + "\n")
            f.close()

            json_data["head"] = {"text": ['tspan', {"class":'error h3'}, 'Simulation failure '],
                                 "tick": 0}
            try:
                output_signals = []
                for element in json_data["signal"]:
                    if len(element) and element[0] == u'OUT':
                        for signal in element[1:]:
                            output_signals.append(signal)
            except KeyError:
                output_signals = []
                print "Dit bericht zou echt nooit mogen verschijnen"

            signals_to_mark = []
            edges_to_add = []
            current_letter = "a"

            original_signals = copy.deepcopy(output_signals)
            for message in warning_logs:
                warning_no, signal_name, expected_value, actual_value, n = message

                edges_to_add.append(current_letter + "-" + alphabet(current_letter, 1) + " W" + warning_no)

                if signal_name not in signals_to_mark:
                    signals_to_mark.append(signal_name)

                # for signal in original_signals:
                for i in range(0, len(original_signals)):
                    signal = original_signals[i]
                    if signal["name"].strip() == signal_name.strip():
                        sim_signal = copy.deepcopy(signal)
                        sim_signal["name"] = signal_name + "_sim"
                        if not is_element(output_signals, sim_signal["name"]):
                            output_signals.insert(i + 1, sim_signal)

                output_signals = fix_error(output_signals, signal_name, actual_value, n)
                json_data, output_signals = add_nodes(json_data, signal_name, output_signals, n, current_letter)
                current_letter = alphabet(current_letter, 2)

            output_signals = mark_signals(output_signals, signals_to_mark)

            for element in json_data["signal"]:
                if len(element) and element[0] == u'OUT':
                    for i in range(0, len(original_signals)):    # for all output signals already in output signals
                        element[i + 1] = output_signals[i]
                    for i in range(0, len(signals_to_mark)):
                        element.append(output_signals[i + len(original_signals)])

            json_data["edge"] = edges_to_add

            read_json.save_json_file(json_data, result_filename, result_dir)
    0  # useless operation to allow code folding
    # </editor-fold>


# - show actual values in signal
def fix_error(signals, signal_name, actual_value, n):
    # <editor-fold desc="show actual values of signal">
    int_n = int(n)
    unicode_actual_value = unicode(actual_value[1])
    signal = find_signal(signals, signal_name)
    signal_wave = list(signal["wave"])
    if signal_wave[int_n + 1] == u'.':
        x = int_n
        while signal_wave[x] == u'.':
            x -= 1
        signal_wave[int_n + 1] = signal_wave[x]
    signal_wave[int_n] = unicode_actual_value
    signal["wave"] = "".join(signal_wave)
    return signals
    # </editor-fold>


def alphabet(letter, shift):
    # <editor-fold desc="Return next letter in the alphabet">
    # TODO: this will provide problems if there are more then 13 errors in one file, because there are only 26 labels
    start = "a"
    diff = ord(letter) + shift - ord(start)
    return chr(ord(start) + diff % 26)
    # </editor-fold>


def is_element(output_signals, signal_name):
    # <editor-fold desc="return true if a signal with a specific signal name is already present">
    names = []
    for signal in output_signals:
        names.append(signal["name"])
    return signal_name in names
    # </editor-fold>


# - add nodes to signal
def add_nodes(json_data, signal_name, output_signals, n, letter):
    # <editor-fold desc="Add nodes to signal">
    letter_buff = letter

    signal_name = signal_name.strip()
    sim_signal_name = signal_name.strip() + "_sim"

    signals = [find_signal(output_signals, signal_name), find_signal(output_signals, sim_signal_name)]
    for signal in signals:
        if signal is not None:
            try:
                current_length = len(signal["node"])
            except KeyError:
                signal["node"] = ""
                current_length = 0
            for i in range(current_length, int(n)):
                signal["node"] += "."
            signal["node"] += letter_buff
            letter_buff = alphabet(letter_buff, 1)
    return json_data, output_signals
    # </editor-fold>


# - find a signal with signal name in a collection of signals
def find_signal(signals, signal_name):
    # <editor-fold desc="Find a signal with signal name in a collection of signals">
    for signal in signals:
        if signal_name.strip() == signal["name"].strip():
            return signal
    return None
    # </editor-fold>


# mark all signals in red
def mark_signals(output_signals, signal_names):
    # <editor-fold desc="Mark all necessary signals in red">
    for name in signal_names:
        signal = find_signal(output_signals, name)
        sim_signal = find_signal(output_signals, name + "_sim")
        signal["name"] = ['tspan', {"class":'error h4'}, name]
        sim_signal["name"] = ['tspan', {"class":'error h4'}, name + "_sim"]

    return output_signals
    # </editor-fold>


def get_info(filename):
    # <editor-fold desc="Get the warning messages from the csv file, the csv file name and the json data">
    with open(filename, 'r') as log_file:
        e = filename.find("result.csv")
        log_reader = csv.reader(log_file)
        log_list = list(log_reader)
        with open(filename[:e] + "messages.csv", 'r') as message_file:
            message_reader = csv.reader(message_file)
            message_list = list(message_reader)

    # transform lists into useful format
    warning_logs, warning_messages = get_logs_and_messages(log_list, message_list)

    e = filename.find(".")
    s = filename.find("/")
    previous_s = e
    while s != previous_s:
        previous_s = s
        s = filename.rfind('/', s)

    e = filename.find("__")
    json_filename = json_resource_path + filename[s:e] + ".json"        # full json filename from original filename
    # print json_filename
    json_data = read_json.open_json_file(json_filename)

    result_filename = filename[s:e] + "_result.json" # name for newly generated file
    return result_filename, warning_messages, warning_logs, json_data
    # </editor-fold>


def get_logs_and_messages(original_log_list, original_message_list):
    # <editor-fold desc="Get all logs and messages">
    temporary_log_list = []
    temporary_message_list = []

    final_log_list = []
    final_message_list = []

    for i in range(0, len(original_log_list)):
        temporary_log_list.append([])
        temporary_message_list.append([])
        s1 = original_message_list[i][6].find(".") + 1
        s2 = s1 + original_message_list[i][6][s1:].find(".") + 1
        temporary_message_list[i].append(original_message_list[i][6][s2 + 1:])
        temporary_message_list[i].append(original_message_list[i][7])
        for element in original_log_list[i][6:11]:
            temporary_log_list[i].append(element)

    if len(temporary_log_list):
        for i in range(0, len(temporary_log_list)):
            log_element = temporary_log_list[i]
            message_element = temporary_message_list[i]
            if not is_in(final_log_list, log_element):
                final_log_list.append(log_element)
                final_message_list.append(message_element)

    return final_log_list, final_message_list
    # </editor-fold>


# - check whether list element is in list
def is_in(list, list_el):
    # <editor-fold desc="Check whether list element is in list">
    for element in list:
        if list_el[1:] == element[1:]:
            return True
    return False
    # </editor-fold>