
library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_entity_name_gen is
	generic(runner_cfg : runner_cfg_t);
end entity;

architecture entity_name_generated_testbench of tb_entity_name_gen is
	shared variable warning_logger : checker_t;
	shared variable message_logger : checker_t;
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
	
begin
	dut : UUT PORT MAP();

	checker_initiation : checker_init(warning, "", "vunit_out/warning_log/entity_name_messages_old.csv", level, off, failure, ',', false);
	warning_logger_initiation : checker_init(warning_logger, warning, "", "vunit_out/warning_log/entity_name_result.csv", level, verbose_csv, failure, ',', false);
	message_logger_initiation : checker_init(message_logger, warning, "", "vunit_out/warning_log/entity_name_messages.csv", level, verbose_csv, failure, ',', false);

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