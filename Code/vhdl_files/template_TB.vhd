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

entity tb_entity_name_gen is
	generic(runner_cfg : runner_cfg_t);
end entity;

architecture entity_name_generated_testbench of tb_entity_name_gen is
	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT uut
		PORT();
	END COMPONENT;

	--# Clock Signals
	
	--# Input Signals

	--# Output Signals

begin
	dut : UUT PORT MAP();

	checker_initiation : checker_init(error, "", "error.csv", level, off, failure, ',', false);

	main : process
	begin
		test_runner_setup(runner, runner_cfg);

		while test_suite loop
			reset_checker_stat;
			if run("test_name") then
				--# test stimulus
--/				report "This will pass";	/--
				
				wait for 15 ns;
				--# test checking
--				check(sig_F = '1', "Expected sig_F = '1' at this point");
				
--/				-- hardcoded for testing purposes:
				-- --------------------------------------------------------
--			wait for 15 ns;
--				check(sig_F = '1', "Expected sig_F = '1' at this point");
--
--			elsif run("test_fail") then
--				check(false, "This will fail");
--				assert false report "It fails";
--
--			elsif run("test_1") then
--				sig_A <= '0';
--				sig_B <= '0';
--				wait for 15 ns;
--				check(sig_F = '0', "Expected sig_F = '0' at this point");
--
--			elsif run("test_2") then
--				sig_A <= '0';
--				sig_B <= '1';
--				wait for 15 ns;
--				check(sig_F = '0', "Expected sig_F = '0' at this point");
--
--			elsif run("test_3") then
--				sig_A <= '1';
--				sig_B <= '0';
--				wait for 15 ns;
--				check(sig_F = '0', "Expected sig_F = '0' at this point");
--
--			elsif run("test_4") then
--				sig_A <= '1';
--				sig_B <= '1';
--				wait for 15 ns;
--				check(sig_F = '1', "Expected sig_F = '1' at this point"); /--
			end if;
		end loop;

		test_runner_cleanup(runner);
	end process;

end architecture;
---------------------------------------------------------END