# About this project

This project is partialy based on VUnit. It creates VHDL unit tests from timing diagrams that can be automaticaly run using vunit.

# project input files

## standard input file

This project uses [Wavedrom](http://wavedrom.com/) files as the base for its input file. Some fields have been added to the standard JSON output file and should always be included as shown in the example below. The added fields are:
* name(*) : this should be the exact name of the unit under test
* test : this is the name for this test
* description : holds the descrition for this test
* type : should be specified for every signal; The type specifies the VHDL logic type for this signal
* vector_size : for vectors (like tdata in the example below) the vector size should also be specified. This is the amount of bits that the vector represents
* data : The data that the vector holds should be specified in this list. 

Next to these extra fields, each signal should be placed under the apropriate label. All input signals for example should be under one "IN" label. The clock signal is regarded as a special case input signal and is treated seperately.

## extra feature

It is possible simulate a period where the input never changes. By using the '|' character in a wave trace and the 'loop_times' list specified in the clock signal one can specify the exact moment the period should start and the amount of clock cycles it should last. In this example the no-change period starts at the eighth clock period and lasts for 10*434 clock periods. This is the time required for the design to send 10 bits over tx (one start and one stop bit, and the data from tdata sent sequentialy).

For obvious reasons this feature can only be used for timed designs.

# example

```json

{"name": "uart_tx", "test" : "test", "description": "some description", "signal": [
  {},
  ["CLK",
   {"name": "clk", "wave": "n......|", "type":"std_logic", "period": "2", "loop_times" : ["10*434"]}],
  ["IN",
   {"name": "tvalid", "wave": "0.1..0........|.", "type": "std_logic"},
   {"name" : "tdata", "wave": "=.=..=........|.", "data": ["0", "249", "0"], "type" : "std_logic_vector", "vector_size" : "8"}
   ],
  ["OUT",
   {"name": "tx", "wave": "1....0........|.", "type": "std_logic"},
   {"name": "tready", "wave": "01.0..........|.", "type": "std_logic"}
  ]
]}

```
the generated wave trace file looks like this:
![Wavedrom example](http://s16.postimg.org/v9i56ktn9/example.png)

# Dependencies

This project requires:
 *  Python 2.7 or newer
 *  a working installation of [vunit](http://vunit.github.io/installing.html)

