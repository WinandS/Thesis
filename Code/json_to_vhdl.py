# Generates VHDL signal declaration for given signal in json format.
def generate_signal_declaration(json_signal):
    # print json_signal
    signal_name = json_signal["name"]
    signal_type = json_signal["type"]
    return "    signal sig_" + signal_name + " : " + signal_type + ";"


# Generates signal and PORT declaration and port map for given signal set.
def generate_vhdl(json_signal_set):
    i = 0
    signal_types = ["clk", "in", "out"]
    port_declaration = "PORT(\n"
    port_map = "PORT MAP(\n"
    signal_declarations = [[], [], []]
    first = True
    for signal_type in json_signal_set: # there's three types of signals: CLK, IN and OUT.
                                        # (clk is a special case of input signal)
        if len(signal_type) > 0:
            direction = signal_types[i]
            for signal in signal_type:
                if first:
                    new_port = signal["name"] + " : " + direction + " " + signal["type"]
                    new_map = signal["name"] + " => sig_" + signal["name"]
                    first = False
                else:
                    new_port = ";\n" + signal["name"] + " : " + direction + " " + signal["type"]
                    new_map = ",\n" + signal["name"] + " => sig_" + signal["name"]
                port_declaration += new_port
                port_map += new_map

                signal_decl = generate_signal_declaration(signal)
                signal_declarations[i].append(signal_decl)
        i += 1
    port_declaration += " );"
    port_map += " );"
    return port_declaration, port_map, signal_declarations
