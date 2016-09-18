# About this project

The goal of this project is to create a VHDL verification tool where user input is reduced to a minimum, while automaticaly creating documentation at the same time. This is realised by using the same document as a base for creating wave traces as well as testbenches. For this approach to work this document should satisfy certain requirements. These requirements are specified below.

The testbenches being created are based on VUnit. They hold unit tests that can are automatically run using an external simulator.

For a detailed analysis of this project, please read the [report](https://github.ugent.be/wseldesl/Thesis/blob/master/Report/Thesis.pdf).

For a shorter introduction, see [this](blog/blog.md) blogpost.

# Dependencies
The final product of this project is a software tool written in Python that can run on any computer that complies to these conditions:
 * It runs a linux distribution (developed on Ubuntu 14.04 LTS) or a Windows distribution (tested on Windows 10)
 * It has at least Python 2.7 installed
 * It has [VUnit](http://vunit.github.io/documentation) installed
 * It has [WaveDrom](www.wavedrom.com) intalled
 
# project input files
## Making your own WaveDrom input files
These guidelines will help users to create WaveDrom files compatible with the system. Normal operation is not guaranteed when these guidelines are not respected.

### Standard input files
This project uses WaveDrom files as the base for its input file. Some fields have been added to the standard JSON file and should always be included as shown in the example below. The added fields are:
* name(*) : this should be the exact name of the unit under test
* test : this is the name for this test
* description : holds the description for this test
* type : should be specified for every signal; The type specifies the VHDL logic type for this signal
* vector_size : for vectors (like tdata in the example below) the vector size should also be specified. This is the amount of bits that the vector represents
* data : The data that the vector holds should be specified in this list
* clock_period (optional): The designer can specify a clock signal, otherwise the clock period will default to 20 ns

Next to these extra fields, each signal should be placed under the apropriate label. All input signals should be under one "IN" label, all output signals under one "OUT" label and the clock signal under the "CLK" label. The clock signal is regarded as a special case input signal and is treated seperately.
### Unicode keys
Although WaveDrom supports non unicode keys. e.g.:
```java
{period : 2}
```
The python JSON package used does not. Because of this all keys must be unicode strings. e.g.:
```java
{"period" : 2}
```
### Supported characters
Not all wavedrom characters are currently supported. The supported characters are:

In a clock signal:
```java
{'n', 'p', '.', '|'}
```
In an input signal: 
```java
{'1', '0', '.', '='}
```
In an output signal: 
```java
{'1', '0', '.', '=', 'x'}
```
## extra features
### time loops ('|')
It is possible simulate a period where the input never changes. By using the '|' character in the clock signal and the 'loop_times' field the moment this period should start and the amount of clock cycles it should last can be specified. In the example below, the first loop period starts at the eighth clock period and lasts for 10*434 clock periods. This is the time required for the design to send 10 bits over tx (one start and one stop bit, and the data from tdata sent sequentialy). During this loop the checks at this moment are repeated every clock cycle. For obvious reasons this feature can only be used when a clock signal is present.

### check skipping ('x')
In some cases the output at a specific point in time is undefined or is of no interest to the designer. In this case the designer can use the 'x' character, which means that the signal should not be checked at this point. This character is only valid for output signals.


## example
Here is an example input file testing the design of an UART transmitter design "uart_tx" available [here](https://github.ugent.be/wseldesl/Thesis/tree/master/examples/uart/vhdl_files/src). Two consecutive bytes are sent over the serial output port. Input signals as well as expected output signals are defined.

```json
{"name": "uart_tx", "test" : "uart_send_2_bytes", "description": "A test for sending two consecutive bytes with an parallel to serial uart", "signal": [
	["CLK",
		{"name": "clk", "wave": "n......|n......|", "type":"std_logic", "period": "2", "clock_period": "10", "loop_times" : ["10*434", "10*434"]}],
	["IN",
		{"name": "tvalid", "wave": "0.1..0............1..0..........", "type": "std_logic"},
		{"name" : "tdata", "wave": "=.=..=........x.==..=.........x.", "data": ["0", "249", "0", "0", "127", "0"], "type" : "std_logic_vector", "vector_size" : "8"}],
	["OUT",
		{"name": "tx", "wave": "1....0........x.1....0........x.", "type": "std_logic"},
		{"name": "tready", "wave": "01.0..........x.1..0..........x.", "type": "std_logic"}]
]}
```
the generated wave trace file looks like this:

![Wavedrom example](https://github.ugent.be/wseldesl/Thesis/blob/master/Report/images/uart_2_bytes_failing.png)

# Starting the tool
 * Make sure you have met all requirements for running the program 
 * Download the software as a zip file
 * Extract the zip file
 * Go to the Code folder
 * Run main.py
 * Click 'open input folder' and add input files
 * Click 'open design folder' and add design file to test
 * Click start button
 * Click 'open output folder'
 * Open result waveJSON files in WaveDrom and corresponding text file for error messages

# More examples
more examples can be found [here](https://github.ugent.be/wseldesl/Thesis/tree/master/examples). Every example contains 
 * The design to be tested in the 'src' folder
 * The WaveDrom file from which the test is generated in the 'json resources' folder
 * The generated test in the 'test' folder

The example can be run by executing the run.py file contained in every folder. For extra information on execution parameters, see: [VUnit usage](http://vunit.github.io/cli.html#usage)

