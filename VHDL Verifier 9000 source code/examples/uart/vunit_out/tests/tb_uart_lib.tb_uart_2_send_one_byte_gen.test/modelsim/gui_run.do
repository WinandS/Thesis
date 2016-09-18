do /home/winand/Documents/Schoolwerk/Masterproef/Thesis/examples/uart/vunit_out/tests/tb_uart_lib.tb_uart_2_send_one_byte_gen.test/modelsim/common.do
# Do not exclude variables from log
if {![vunit_load -vhdlvariablelogging]} {
  quietly set WildcardFilter [lsearch -not -all -inline $WildcardFilter Process]
  quietly set WildcardFilter [lsearch -not -all -inline $WildcardFilter Variable]
  quietly set WildcardFilter [lsearch -not -all -inline $WildcardFilter Constant]
  quietly set WildcardFilter [lsearch -not -all -inline $WildcardFilter Generic]
  log -recursive /*"
  quietly set WildcardFilter default
  vunit_run
}
