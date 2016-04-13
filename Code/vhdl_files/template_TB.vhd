------------------------------------------------------------
-- Based on code from  : http://www.teahlab.com/
--
-- Author: Winand Seldeslachts
--
-- Program : AND Gate Testbench
--
-- Note    : A testbench is a program that defines a set
--         of input signals to verity the operation of
--         a circuit: in this case, the AND Gate.
--	
--         1] The testbench takes no inputs and returns
--         no outputs. As such the ENTITY declaration
--         is empty.
--
--         2] The circuit under verification, here the
--         AND Gate is imported into the testbench
--         ARCHITECTURE as a component.
------------------------------------------------------------

--import std_logic from the IEEE library
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
	

begin
	dut : UUT PORT MAP();

	checker_initiation : checker_init(warning, "", "vunit_out/error.csv", level, off, failure, ',', false);

	main : process
		variable n : integer := 0;
		variable v : integer := 0;
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