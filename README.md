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

# What is VUnit?

VUnit is an open source unit testing framework for VHDL released under the terms of Mozilla Public License, v. 2.0. It features the functionality needed to realize continuous and automated testing of your VHDL code. VUnit doesn't replace but rather complements traditional testing methodologies by supporting a "test early and often" approach through automation.

# Project Mission

The VUnit project mission is to apply best SW testing practises to the world of VHDL by providing the tools missing to adapt to such practises. The major missing piece is the unit testing framework, hence the name V(HDL)Unit. However, VUnit also provides supporting functionality not normally considered as a part of an unit testing framework.

# Main Features
* Builds on the commonly used [xUnit](http://en.wikipedia.org/wiki/XUnit) architecture.
* Python test runner that enables powerful test administration, can handle VHDL fatal run-time errors (e.g. division by zero), and ensures test case independence.
* Scanners for identifying files, tests, file dependencies, and file changes enable for automatic (re)compilation and execution of test suites.
* Can run test cases in parallel to take advantage of multi-core machines.
* Scripting as well as command line support.
* Support for running same test suite with different generics.
* VHDL test runner which enables test execution for not fully supported simulators.
* Assertion checker library that extends VHDL built-in support (assert).
* Logging framework supporting display and file output, different log levels, filtering on level and design hierarchy, output formatting and multiple loggers. Spreadsheet tool integration.
* Location preprocessor that traces log and check calls back to file and line number.
* JUnit report files for better [Jenkins](http://jenkins-ci.org/) integration.

# Requirements
VUnit depends on a number of components as listed below. Full VUnit functionality requires Python and a simulator supported by the VUnit Python test runner. However, VUnit can run with limited functionality entirely within VHDL which means that unsupported simulators can be used as well. Prototype work has been done to fully support other simulators but this work is yet to be completed and released.
## VHDL
* VHDL-93
* VHDL-2002
* VHDL-2008

## Operating systems
* Windows
* Linux
* Mac OS X

## Python
* Python 2.7
* Python 3.3 or higher

## Simulators
* [Aldec Riviera-PRO](https://www.aldec.com/en/products/functional_verification/riviera-pro])
  * Tested with Riviera-PRO-2015.06 (x64/x86).
  * Only VHDL 2008
* [Aldec Active-HDL](https://www.aldec.com/en/products/fpga_simulation/active-hdl)
  * Tested with Active-HDL-10.2 (x64/x86)
  * Only VHDL 2008
* [Mentor Graphics ModelSim/Questa](http://www.mentor.com/products/fv/modelsim/)
  * Tested with 10.1 - 10.3
* [GHDL](https://sourceforge.net/projects/ghdl-updates/)
  * Only VHDL 2008
  * Only versions >= 0.33 dev (There is no official release yet, must be built from source)
  * Tested with LLVM and mcode backends, gcc backend might work aswell.
  * Integrated support for using [GTKWave](http://gtkwave.sourceforge.net/) to view waveforms.

# Getting Started
There are a number of ways to get started.

*  The [VUnit User Guide](user_guide.md) will guide users on how to use start using the basic features of VUnit but also provides information about more specific and advanced usage.
*  The [Check User Guide](vhdl/check/user_guide.md) presents the check package.
*  The [Log User Guide](vhdl/logging/user_guide.md) presents the log package.
*  Have a look at the examples under [examples](examples). The examples in [logging](examples/vhdl/logging) and [check](examples/vhdl/check) are tutorials that should be single-stepped in your simulator.
*  There are also various presentations of VUnit on [YouTube](https://www.youtube.com/channel/UCCPVCaeWkz6C95aRUTbIwdg). For example [an introduction to unit testing (6 min)](https://www.youtube.com/watch?v=PZuBqcxS8t4) and a [short introduction to VUnit (12 min)](https://www.youtube.com/watch?v=D8s_VLD91tw).

# Contributing
Contributing in the form of code, feedback, ideas or bug reports are welcome.
Before contributing code read our [Development document](developing.md).

# Support
Any bug reports, feature requests or questions about the usage of VUnit can be made by creating a [new issue](https://github.com/LarsAsplund/vunit/issues/new). The issue should be labeled accordingly using the built-in labels; *bug*, *enhancement* or *question*.

# Main Contributors
* Lars Asplund
* Olof Kraigher

# License
## VUnit
VUnit except for OSVVM (see below) is released under the terms of [Mozilla Public
License, v. 2.0](http://mozilla.org/MPL/2.0/).

&copy; 2014-2015 Lars Asplund, lars.anders.asplund@gmail.com.

##OSVVM
OSVVM 2015.03 is redistributed with VUnit for your convenience and is located under [vhdl/osvvm](vhdl/osvvm). Minor [modifications](https://github.com/LarsAsplund/vunit/commit/25fce1b3700e746c3fa23bd7157777dd4f20f0d6) have been made to enable GHDL support. Derivative work is also located under [examples/vhdl/osvvm\_integration/src](examples/vhdl/osvvm_integration/src). These files are licensed under the terms of [ARTISTIC License](http://www.perlfoundation.org/artistic_license_2_0).

&copy; 2010 - 2015 by SynthWorks Design Inc.  All rights reserved.
