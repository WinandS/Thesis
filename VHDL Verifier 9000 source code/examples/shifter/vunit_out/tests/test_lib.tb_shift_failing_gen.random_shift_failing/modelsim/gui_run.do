do /home/winand/Documents/Schoolwerk/Masterproef/Thesis/examples/shifter/vunit_out/tests/test_lib.tb_shift_failing_gen.random_shift_failing/modelsim/common.do
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
