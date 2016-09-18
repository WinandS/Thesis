do /home/winand/Documents/Schoolwerk/Masterproef/Thesis/examples/shifter/vunit_out/tests/tb_uart_lib.tb_shift_gen.test/modelsim/common.do
quietly set failed [vunit_load]
if {$failed} {quit -f -code 1}
quietly set failed [vunit_run]
if {$failed} {quit -f -code 1}
quit -f -code 0
