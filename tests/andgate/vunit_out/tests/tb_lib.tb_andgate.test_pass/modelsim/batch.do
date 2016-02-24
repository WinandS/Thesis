do /home/winand/Documents/Google\ Drive/Schoolwerk/Masterproef/Thesis/tests/andgate/vunit_out/tests/tb_lib.tb_andgate.test_pass/modelsim/common.do
quietly set failed [vunit_load]
if {$failed} {quit -f -code 1}
quietly set failed [vunit_run]
if {$failed} {quit -f -code 1}
quit -f -code 0
