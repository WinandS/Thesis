# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2014-2015, Lars Asplund lars.anders.asplund@gmail.com

from os.path import join, dirname
from vunit import VUnit

src_path = join(dirname(__file__), "src")

ui = VUnit.from_argv()

desc_lib = ui.add_library("desc_lib")
desc_lib.add_source_files(join(src_path, "*.vhd"))

tb_lib = ui.add_library("tb_lib")
tb_lib.add_source_files(join(src_path, "test", "*.vhd"))

ui.main()
