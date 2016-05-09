do /home/winand/Documents/Schoolwerk/Masterproef/Thesis/examples/uart/vunit_out/tests/test_lib.tb_uart_3_send_two_bytes_gen.uart_send_2_bytes/modelsim/common.do
quietly set failed [vunit_load]
if {$failed} {quit -f -code 1}
quietly set failed [vunit_run]
if {$failed} {quit -f -code 1}
quit -f -code 0
