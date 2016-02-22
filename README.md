# About this project

This project is partialy based on VUnit. It creates VHDL unit tests from timing diagrams that can be automaticaly run using vunit.

# project input files

This project uses [Wavedrom](http://wavedrom.com/) files as the base for its input file. Some fields have been added to the standard JSON output file and should always be included as shown in the example below. The added fields are:
* name(*) : this should be the exact name of the unit under test
* test : this is the name for this test
* description : holds the descrition for this test
* type : should be specified for every signal; The type specifies the VHDL logic type for this signal

Next to these extra fields, each signal should be placed under the apropriate label. All input signals for example should be under one "IN" label. The clock signal is regarded as a special case input signal and is treated seperately.

# example

```json
{"name": "andGate", "test" : "test1", "description": "this is an input example", "signal": [
  ["CLK",
   {"name": "CLK", "wave": "p..............", "type": "std_logic"}],
  ["IN",
   {"name": "A", "wave": "0..10..10......", "type": "std_logic"},
   {"name": "B", "wave": "0......10...10.", "type": "std_logic"}],
  ["OUT", 
   {"name": "C", "wave": "0......10......", "type": "std_logic"}]
]}
```
# Dependancies

This project requires:
 *  Python 2.7 or newer
 *  a working installation of [vunit](https://github.com/vunit/vunit)

