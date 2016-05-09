do /home/winand/Documents/Schoolwerk/Masterproef/Thesis/examples/spi/vunit_out/tests/test_lib.tb_spi_gen.SPI_send_one_byte/modelsim/common.do
quietly set failed [vunit_load]
if {$failed} {quit -f -code 1}
quietly set failed [vunit_run]
if {$failed} {quit -f -code 1}
quit -f -code 0
