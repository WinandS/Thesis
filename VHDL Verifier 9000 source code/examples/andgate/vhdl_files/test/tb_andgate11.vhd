-- ---------------------------------------------------
-- Author: 
-- Test name: andgate11
-- Test description: input A = '1' & B = '1' should produce a high output
-- ---------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_andgate11_gen is
	generic(runner_cfg : runner_cfg_t);
end entity;

architecture andgate11_generated_testbench of tb_andgate11_gen is
	shared variable warning_logger : checker_t;
	COMPONENT andGate

		PORT(
A : in std_logic;
B : in std_logic;
F : out std_logic );

	END COMPONENT;
	
	--# Clock Cycles
constant clock_cycles : integer := 2;
	
	--# Wait Times
	
	--# Relative Period
	
	--# Helper Types
type std_logic_array is array (0 to clock_cycles - 1) of std_logic;

	
	--# Constants
constant sig_A_values : std_logic_array := ( '1', '0');
constant sig_B_values : std_logic_array := ( '1', '0');
constant sig_F_values : std_logic_array := ( '1', '0');


	--# Timing Signals
		
	--# Clock Signals
	
	--# Input Signals
    signal sig_B : std_logic := sig_B_values(0);
    signal sig_A : std_logic := sig_A_values(0);

	--# Output Signals
    signal sig_F : std_logic := sig_F_values(0);
	
	--# Simulation Signals
	
begin
	dut : andGate PORT MAP(
A => sig_A,
B => sig_B,
F => sig_F );


	checker_initiation : checker_init(warning, "", ".warning_log/andgate11__andgate11_messages.csv", level, verbose_csv, failure, ',', false);
	warning_logger_initiation : checker_init(warning_logger, warning, "", ".warning_log/andgate11__andgate11_result.csv", level, verbose_csv, failure, ',', false);

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

			if run("andgate11") then
				
				--# Loop start
				
				--# sig_n driver
				
				--# Extra Code For Waiting
	
					sig_A <= sig_A_values(n);
sig_B <= sig_B_values(n);

					
					
					wait for 10 ns;
					
					
 if sig_F_values(n) /= 'X' then
check(warning_logger,  sig_F = sig_F_values(n), integer'image(error_number) & ",F," & std_logic'image(sig_F_values(n)) & "," &  std_logic'image(sig_F) & "," & integer'image(n) , line_num => error_number);
check(sig_F = sig_F_values(n), integer'image(error_number) & ". This check failed. Expected sig_F =  " & std_logic'image(sig_F_values(n)) & ", got sig_F =  " & std_logic'image(sig_F) & " at n = " & integer'image(n) & "." );
if sig_F /= sig_F_values(n) then
error_number := error_number + 1;
end if;
end if;

	
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