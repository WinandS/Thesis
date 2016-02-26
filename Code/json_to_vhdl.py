# Generates VHDL signal declaration for given signal in json format.
def generate_signal_declaration(json_signal):
    # print json_signal
    signal_name = json_signal["name"]
    signal_type = json_signal["type"]
    return "    signal sig_" + signal_name + " : " + signal_type + " := '0';"


# convert given wavedrom character to correct vhdl character
def convert_special_cases(char, previous_char):
    if char == ".":
        char = previous_char
    elif char == "p":
        char = "1', '0"
    elif char == "n":
        char = "0', '1"
    return char


# convert given json waveform to string of a vhdl array
def convert_wave_to_array(json_wave, signal_period):
    # TODO: fix this cheating
    if len(json_wave) == 1:
        json_wave += "0"

    # convert first element
    value = json_wave[0]

    # convert special cases
    value = convert_special_cases(value, "0")

    array_string = "'" + value + "'"
    for n in range(1, signal_period):
        array_string += ", '" + value + "'"

    # hold first element and continue to add rest of waveform
    previous_value = value
    if len(json_wave) > 1:
        for i in range(1, len(json_wave)):
            value = json_wave[i]

            value = convert_special_cases(value, previous_value)

            for n in range(0, signal_period):
                array_string += ", '" + value + "'"

            previous_value = value
    return array_string


# generate a string containing the vhdl declaration of a constant.
# this constant holds all relevant info of a signal waveform
def generate_signal_values_constant(json_signal, is_clock):
    if "period" in json_signal:
        signal_period = int(json_signal["period"])
    else:
        signal_period = 1

    array_type = ""
    if is_clock > 0:
        array_type += "clk_"
    array_type += json_signal["type"] + "_array"

    signal_wave = json_signal["wave"]

    wave_array = convert_wave_to_array(signal_wave, signal_period)

    signal_value_statement = "constant sig_" + json_signal["name"] + "_values : " \
                             + array_type + " := (" + wave_array + ");"
    return signal_value_statement


# def generate_signal_declaration_set(json_signal_set):
#     i = 0
#     signal_types = ["clk", "in", "out"]
#     TODO: continue this


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
                    values_constant = generate_signal_values_constant(signal, 1-i)
                    signal_values.append(values_constant)

        i += 1
    port_declaration += " );"
    port_map += " );"
    return port_declaration, port_map, signal_declarations, signal_values


