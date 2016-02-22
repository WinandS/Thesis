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
--         AND Gate, is imported into the testbench
--         ARCHITECTURE as a component.
------------------------------------------------------------

--import std_logic from the IEEE library
library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_andgate00_gen is
	generic(runner_cfg : runner_cfg_t);
end entity;

architecture andgate00_generated_testbench of tb_andgate00_gen is
	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT andGate

		PORT(
A : in std_logic;
B : in std_logic;
F : out std_logic );

	END COMPONENT;

	--# Clock Signals
	
	--# Input Signals 
    signal sig_B : std_logic; 
    signal sig_A : std_logic;

	--# Output Signals 
    signal sig_F : std_logic;

begin
	dut : andGate PORT MAP(
A => sig_A,
B => sig_B,
F => sig_F );


	checker_initiation : checker_init(error, "", "error.csv", level, off, failure, ',', false);

	main : process
	begin
		test_runner_setup(runner, runner_cfg);

		while test_suite loop
			reset_checker_stat;
			if run("test1") then
				sig_A <= '0';
sig_B <= '0';

				
				wait for 15 ns;
				check( sig_F = '0', " Expected sig_F = '0' at this point");
--				check(sig_F = '1', "Expected sig_F = '1' at this point");
				
			end if;
		end loop;

		test_runner_cleanup(runner);
	end process;

end architecture;
---------------------------------------------------------END