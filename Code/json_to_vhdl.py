# Generates all necessary VHDL code for given signal in json format. (only signal declaration for now)
def translate(json_signal):
    signal_name = json_signal["name"]
    signal_declaration = "    signal " + signal_name + " : std_logic := '0';"
    # signal_waveform = json_signal["wave"]
    return signal_declaration