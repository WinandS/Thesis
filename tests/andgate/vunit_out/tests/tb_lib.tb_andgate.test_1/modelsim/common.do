
proc vunit_help {} {
    echo {List of VUnit modelsim commands:}
    echo {vunit_help}
    echo {  - Prints this help}
    echo {vunit_load [vsim_extra_args]}
    echo {  - Load design with correct generics for the test}
    echo {  - Optional first argument are passed as extra flags to vsim}
    echo {vunit_run}
    echo {  - Run test, must do vunit_load first}
}

proc vunit_load {{vsim_extra_args ""}} {
    set vsim_failed [catch {
        eval vsim ${vsim_extra_args} {-wlf {/home/winand/Documents/Google\ Drive/Schoolwerk/Masterproef/Thesis/tests/andgate/vunit_out/tests/tb_lib.tb_andgate.test_1/modelsim/vsim.wlf} -quiet -t ps -onfinish stop  -g/tb_andgate/runner_cfg={"enabled_test_cases : test_1,output path : /home/winand/Documents/Google Drive/Schoolwerk/Masterproef/Thesis/tests/andgate/vunit_out/tests/tb_lib.tb_andgate.test_1/,active python runner : true"} tb_lib.tb_andgate(tb)   -L vunit_lib -L desc_lib -L tb_lib}
    }]
    if {${vsim_failed}} {
       echo Command 'vsim ${vsim_extra_args} -wlf {/home/winand/Documents/Google\ Drive/Schoolwerk/Masterproef/Thesis/tests/andgate/vunit_out/tests/tb_lib.tb_andgate.test_1/modelsim/vsim.wlf} -quiet -t ps -onfinish stop  -g/tb_andgate/runner_cfg={"enabled_test_cases : test_1,output path : /home/winand/Documents/Google Drive/Schoolwerk/Masterproef/Thesis/tests/andgate/vunit_out/tests/tb_lib.tb_andgate.test_1/,active python runner : true"} tb_lib.tb_andgate(tb)   -L vunit_lib -L desc_lib -L tb_lib' failed
       echo Bad flag from vsim_extra_args?
       return 1
    }
    set no_finished_signal [catch {examine -internal {/vunit_finished}}]
    set no_vhdl_test_runner_exit [catch {examine -internal {/run_base_pkg/runner.exit_simulation}}]
    set no_verilog_test_runner_exit [catch {examine -internal {/vunit_pkg/__runner__}}]

    if {${no_finished_signal} && ${no_vhdl_test_runner_exit} && ${no_verilog_test_runner_exit}}  {
        echo {Error: Found none of either simulation shutdown mechanisms}
        echo {Error: 1) No vunit_finished signal on test bench top level}
        echo {Error: 2) No vunit test runner package used}
        return 1
    }

    
    return 0
}

proc _vunit_run {} {
    global BreakOnAssertion
    set BreakOnAssertion 2

    global NumericStdNoWarnings
    set NumericStdNoWarnings 0

    global StdArithNoWarnings
    set StdArithNoWarnings 0

    proc on_break {} {
        resume
    }
    onbreak {on_break}

    set has_vunit_finished_signal [expr ![catch {examine -internal {/vunit_finished}}]]
    set has_vhdl_runner [expr ![catch {examine -internal {/run_base_pkg/runner.exit_simulation}}]]
    set has_verilog_runner [expr ![catch {examine -internal {/vunit_pkg/__runner__}}]]

    if {${has_vunit_finished_signal}} {
        set exit_boolean {/vunit_finished}
        set status_boolean {/vunit_finished}
        set true_value TRUE
    } elseif {${has_vhdl_runner}} {
        set exit_boolean {/run_base_pkg/runner.exit_simulation}
        set status_boolean {/run_base_pkg/runner.exit_without_errors}
        set true_value TRUE
    } elseif {${has_verilog_runner}} {
        set exit_boolean {/vunit_pkg/__runner__.exit_simulation}
        set status_boolean {/vunit_pkg/__runner__.exit_without_errors}
        set true_value 1
    } else {
        echo "No finish mechanism detected"
        return 1;
    }

    when -fast "${exit_boolean} = ${true_value}" {
        echo "Finished"
        stop
        resume
    }

    run -all
    set failed [expr [examine -radix unsigned -internal ${status_boolean}]!=${true_value}]
    if {$failed} {
        catch {
            # tb command can fail when error comes from pli
            echo
            echo "Stack trace result from 'tb' command"
            echo [tb]
            echo
            echo "Surrounding code from 'see' command"
            echo [see]
        }
    }
    return $failed
}

proc vunit_run {} {
    if {[catch {_vunit_run} failed_or_err]} {
        echo $failed_or_err
        return 1;
    }
    return $failed_or_err;
}
