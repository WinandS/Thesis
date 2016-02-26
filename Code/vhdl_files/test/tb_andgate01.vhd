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

entity tb_andgate01_gen is
	generic(runner_cfg : runner_cfg_t);
end entity;

architecture andgate01_generated_testbench of tb_andgate01_gen is
	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT andGate

		PORT(
A : in std_logic;
B : in std_logic;
F : out std_logic );

	END COMPONENT;
	
	--# Clock cycles
constant clock_cycles : integer := 2;
	
	--# Helper types
type std_logic_array is array (0 to clock_cycles - 1) of std_logic;

	
	--# Constants
constant sig_A_values : std_logic_array := ('0', '0');
constant sig_B_values : std_logic_array := ('1', '0');
constant sig_F_values : std_logic_array := ('0', '0');


	--# Timing Signals
		
	--# Clock Signals
	
	--# Input Signals 
    signal sig_B : std_logic := '0'; 
    signal sig_A : std_logic := '0';

	--# Output Signals 
    signal sig_F : std_logic := '0';

begin
	dut : andGate PORT MAP(
A => sig_A,
B => sig_B,
F => sig_F );


	checker_initiation : checker_init(warning, "", "vunit_out/error.csv", level, off, failure, ',', false);

	main : process
		variable n : integer := 0;
	begin
		test_runner_setup(runner, runner_cfg);
		
		while test_suite loop
			reset_checker_stat; 
			n := 0;

			if run("test") then
				--# Loop start
	
	
					sig_A <= sig_A_values(n);
sig_B <= sig_B_values(n);

					
					
					wait for 10 ns;
					
					check( sig_F = sig_F_values(n), "this check failed" );
	
					n := n+1;
				--# Loop end
				--# set endofsimulation
			
			end if;
		end loop;

		test_runner_cleanup(runner);
	end process;
	
	--# Clock driver

end architecture;
---------------------------------------------------------END