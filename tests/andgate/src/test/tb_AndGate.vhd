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

entity tb_andgate is
	generic(runner_cfg : runner_cfg_t);
end entity;

architecture tb of tb_andgate is
	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT AndGate
		PORT(
			A, B : in  std_logic;
			F    : out std_logic
		);
	END COMPONENT;

	--input signals
	signal inA, inB : std_logic;

	--output signal
	signal outF : std_logic;
begin
	dut : AndGate PORT MAP(
			A => inA,
			B => inB,
			F => outF
		);
	
--	checker_initiation: checker_init(error, "", "error.csv", level, off, failure, ',', false);
	
	main : process
	begin
		test_runner_setup(runner, runner_cfg);

		while test_suite loop
			reset_checker_stat;
			if run("test_pass") then
				report "This will pass";

			elsif run("test_fail") then
				check(false, "This will fail");
				assert false report "It fails";

			elsif run("test_1") then
				inA <= '0';
				inB <= '0';
				wait for 15 ns;
				check(outF = '0', "Expected outF = '0' at this point");

			elsif run("test_2") then
				inA <= '0';
				inB <= '1';
				wait for 15 ns;
				check(outF = '0', "Expected outF = '0' at this point");

			elsif run("test_3") then
				inA <= '1';
				inB <= '0';
				wait for 15 ns;
				check(outF = '0', "Expected outF = '0' at this point");

			elsif run("test_4") then
				inA <= '1';
				inB <= '1';
				wait for 15 ns;
				check(outF = '1', "Expected outF = '1' at this point");
			end if;
		end loop;

		test_runner_cleanup(runner);
	end process;

end architecture;
---------------------------------------------------------END