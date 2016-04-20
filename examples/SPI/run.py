# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2014-2015, Lars Asplund lars.anders.asplund@gmail.com

from os.path import join, dirname
from vunit import VUnit

ui = VUnit.from_argv()

dir_path = dirname(__file__)

uart_lib = ui.add_library("uart_lib")
uart_lib.add_source_files(join(dir_path, "src", "*.vhd"))

tb_uart_lib = ui.add_library("tb_uart_lib")
tb_uart_lib.add_source_files(join(dir_path, "test", "*.vhd"))

ui.main()
