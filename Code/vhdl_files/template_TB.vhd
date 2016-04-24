
library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_entity_name_gen is
	generic(runner_cfg : runner_cfg_t);
end entity;

architecture entity_name_generated_testbench of tb_entity_name_gen is
	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT uut
		PORT();
	END COMPONENT;
	
	--# Clock Cycles
	
	--# Wait Times
	
	--# Relative Period
	
	--# Helper Types
	
	--# Constants

	--# Timing Signals
		
	--# Clock Signals
	
	--# Input Signals

	--# Output Signals
	
	--# Simulation Signals
	
	--# Check Procedure
	procedure check_signal(signal_to_check, expected_value : in std_logic; n: in integer; error_number : inout integer ) is
	begin
		if expected_value /= 'X' then
			check(signal_to_check = expected_value, integer'image(error_number) & ". This check failed. Expected F = " & std_logic'image(expected_value) & ", got F = " & std_logic'image(signal_to_check) & " at n = " & integer'image(n) & ".");
			if signal_to_check /= expected_value then
				error_number := error_number + 1;
			end if;
		end if;
	end check_signal;

begin
	dut : UUT PORT MAP();

	checker_initiation : checker_init(warning, "", "vunit_out/error.csv", level, off, failure, ',', false);

	main : process
		variable n : integer := 0;
		variable v : integer := 0;
		variable error_number     : integer := 1;
		--# Wait Variables
		
	begin
		test_runner_setup(runner, runner_cfg);
		
		while test_suite loop
			reset_checker_stat; 
			n := 0;

			if run("test_name") then
				
				--# Loop start
				
				--# sig_n driver
				
				--# Extra Code For Waiting
	
					--# Stimulus rising edge
					
					
					--# Stimulus falling edge
					
					--# test checking
	
					n := n+1;
					--# Extra End If For waiting
				--# Loop end
				
				--# set endofsimulation
			
			end if;
		end loop;

		test_runner_cleanup(runner);
	end process;
	
	--# Clock driver

end architecture;
---------------------------------------------------------END