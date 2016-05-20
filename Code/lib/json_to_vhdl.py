# Generates VHDL signal declaration for given signal in json format.
def generate_signal_declaration(json_signal):
    # print json_signal
    signal_name = json_signal["name"]
    signal_type = json_signal["type"]

    return "    signal sig_" + signal_name + " : " + signal_type + " := 0;"

    try:
        vector_max = str(int(json_signal["vector_size"]) - 1)
        signal_type = signal_type + "(" + vector_max + " downto 0)"
    except KeyError:
        vector_size = 0
    return "    signal sig_" + signal_name + " : " + signal_type + " := sig_" + signal_name + "_values(0);"


# convert given wavedrom character to correct vhdl character
def convert(char, previous_char, signal_period, data, data_index, is_vector, vector_size, is_clock):
    if is_vector:
        return convert_std_logic_vector(char, previous_char, signal_period, data, data_index, vector_size)
    else:
        return convert_std_logic(char, previous_char, signal_period, is_clock), 0


def convert_std_logic_vector(char, previous_char, signal_period, data, data_index, vector_size):

    chars = []
    if char == "|":
            vector_size = -vector_size
    elif char == "x":
        binary_number = "X"
        for i in range(1, vector_size):
            binary_number += "X"
        converted_char = ""
        for i in range(0, signal_period):
            converted_char += ", \"" + binary_number + "\""

        return converted_char, data_index

    elif char == "=":
        data_index += 1

    else:
        return previous_char, data_index

    converted_char = ""
    for i in range(0, signal_period):
        converted_char += ", \"" + dec_to_bin(data[data_index], vector_size) + "\""

    return converted_char, data_index


def dec_to_bin(decimal_number, vector_size):
    if vector_size < 0:
        vector_size = -vector_size
        binary_number = "-"
        for i in range(1, vector_size):
            binary_number += "-"
    else:
        format_string = "{0:0" + str(vector_size) + "b}"
        binary_number = format_string.format(int(decimal_number))
    return binary_number


def convert_std_logic(char, previous_char, signal_period, is_clock):
    chars = []
    if char == ".":
        return previous_char
    elif char == "x":
        if is_clock:
            chars = ["X", "X"]
        else:
            chars = ["X"]
    elif char == "|":
        if is_clock:
            chars = ["-", "-"]
        else:
            chars = ["-"]
    elif char == "p":
        chars = ['1', '0']
    elif char == "n":
        chars = ['0', '1']
    else:
        chars = [char]

    converted_char = ""
    for element in chars:
        for i in range(0, signal_period):
            converted_char += ", '" + str(element) + "'"
    return converted_char


# convert given json waveform to string of a vhdl array
def convert_wave_to_array(json_wave, signal_period, data, is_vector, vector_size, is_clock):
    # TODO: fix this cheating
    # an extra (unused) wave value is added to a wave trace with length 1
    # to support combinatorial testing
    if len(json_wave) == 1:
        json_wave += "0"

    data_index = -1

    # convert first element
    value = json_wave[0]
    value, data_index = convert(value, "0", signal_period, data, data_index, is_vector, vector_size, is_clock)

    # add converted value to final string
    array_string = value

    # hold first element and continue to add rest of waveform
    previous_value = value
    if len(json_wave) > 1:
        for wave_value in json_wave[1:]:
            value, data_index = convert(wave_value, previous_value, signal_period, data,
                                        data_index, is_vector, vector_size, is_clock)
            array_string += value

            previous_value = value
    return array_string[1:]  # remove first "," from generated array


# generate a string containing the vhdl declaration of a constant.
# this constant holds all relevant info of a signal waveform
def generate_signal_values_constant(json_signal, is_clock):
    try:
        signal_period = int(json_signal["period"])
    except KeyError:
        signal_period = 1

    array_type = ""
    if is_clock:
        array_type += "clk_"
    array_type += json_signal["type"] + "_array"

    signal_wave = json_signal["wave"]

    is_vector = True

    vector_size = int(0)
    data = [1, 2]
    try:
        data = json_signal["data"]
        vector_size = int(json_signal["vector_size"])
    except KeyError:
        is_vector = False

    wave_array = convert_wave_to_array(signal_wave, signal_period
                                       , data, is_vector, vector_size, is_clock)

    signal_value_statement = "constant sig_" + json_signal["name"] + "_values : " \
                             + array_type + " := (" + wave_array + ");"
    return signal_value_statement


def generate_port_map(json_signal_set):
    port_map = "PORT MAP(\n"
    first = True
    for signal_type in json_signal_set:     # IN and OUT.
        if len(signal_type) > 0:            # JSON allows empty elements
            for signal in signal_type:
                if len(signal) > 0:         # JSON allows empty elements
                    if first:
                        new_map = signal["name"] + " => sig_" + signal["name"]
                        first = False
                    else:
                        new_map = ",\n" + signal["name"] + " => sig_" + signal["name"]
                    port_map += new_map
    port_map += " );"
    return port_map


# Generates signal and PORT declaration and port map for given signal set.
def generate_vhdl(json_signal_set):
    i = 0
    signal_types = ["in", "in", "out"]
    port_declaration = "PORT(\n"
    port_map = "PORT MAP(\n"
    signal_declarations = [[], [], []]
    signal_values = []
    first = True
    for signal_type in json_signal_set: # there's three types of signals: CLK, IN and OUT.
        # (clk is a special case of input signal)
        if len(signal_type) > 0:
            direction = signal_types[i]
            for signal in signal_type:
                if len(signal) > 0:
                    # port declarations and port map
                    if first:
                        new_port = signal["name"] + " : " + direction + " " + signal["type"]
                        new_map = signal["name"] + " => sig_" + signal["name"]
                        first = False
                    else:
                        new_port = ";\n" + signal["name"] + " : " + direction + " " + signal["type"]
                        new_map = ",\n" + signal["name"] + " => sig_" + signal["name"]
                    port_declaration += new_port
                    port_map += new_map

                    # signal declarations
                    signal_decl = generate_signal_declaration(signal)
                    signal_declarations[i].append(signal_decl)

                    # signal values
                    values_constant = generate_signal_values_constant(signal, (False, True)[1-i > 0])
                    signal_values.append(values_constant)

        i += 1
    port_declaration += " );"
    port_map += " );"
    return port_declaration, port_map, signal_declarations, signal_values


