# About this project

The goal of this project is to create a VHDL verification tool where user input is reduced to a minimum, while automaticaly creating documentation at the same time. This is realised by using the same document as a base for creating wave traces as well as testbenches. For this approach to work this document should satisfy certain requirements. These requirements are specified below.

The testbenches being created are based on VUnit. They hold unit tests that can are automatically run using an external simulator.

# project input files

## standard input file

This project uses [Wavedrom](http://wavedrom.com/) files as the base for its input file. Some fields have been added to the standard JSON file and should always be included as shown in the example below. The added fields are:
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

## example

```json

{"name": "uart_tx", "test" : "uart_send_2_bytes", "description": "A test for sending two consecutive bytes with an parallel to serial uart", "signal": [
  {},
  ["CLK",
   {"name": "clk", "wave": "n......|n......|", "type":"std_logic", "period": "2", "clock_period": "10", "loop_times" : ["10*434", "10*434"]}],
  ["IN",
   {"name": "tvalid", "wave": "0.1..0............1..0..........", "type": "std_logic"},
   {"name" : "tdata", "wave": "=.=..=........x.==..=.........x.", "data": ["0", "249", "0", "0", "127", "0"], "type" : "std_logic_vector", "vector_size" : "8"}
   ],
  ["OUT",
   {"name": "tx", "wave": "1....0........x.1....0........x.", "type": "std_logic"},
   {"name": "tready", "wave": "01.0..........x.1..0..........x.", "type": "std_logic"}
  ]
]}

```
the generated wave trace file looks like this:
![Wavedrom example](http://postimg.org/image/z5gt0wmon/full/)

# More examples
more examples can be found [here](https://github.ugent.be/wseldesl/Thesis/examples). Every example contains 
 * The design to be tested in the 'src' folder
 * The WaveDrom file from which the test is generated in the 'json resources' folder
 * The generated test in the 'test' folder

The example can be run by executing the run.py file contained in every folder. For extra information on execution parameters, see: [VUnit usage](http://vunit.github.io/cli.html#usage)

# Dependencies

This project requires:
 *  Python 2.7 or newer
 *  a working installation of [vunit](http://vunit.github.io/installing.html)



