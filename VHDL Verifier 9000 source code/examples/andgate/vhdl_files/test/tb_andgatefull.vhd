-- ---------------------------------------------------
-- Author: 
-- Test name: andgate_full
-- Test description: test all possible inputs for an AND-gate
-- ---------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_andgatefull_gen is
	generic(runner_cfg : runner_cfg_t);
end entity;

architecture andgatefull_generated_testbench of tb_andgatefull_gen is
	shared variable warning_logger : checker_t;
	COMPONENT andGate_timed

		PORT(
CLK : in std_logic;
A : in std_logic;
B : in std_logic;
F : out std_logic );

	END COMPONENT;
	
	--# Clock Cycles
constant clock_cycles : integer := 14;
	
	--# Wait Times
	
	--# Relative Period
	
	--# Helper Types
type clk_std_logic_array is array (0 to 2*clock_cycles - 1) of std_logic;
type std_logic_array is array (0 to clock_cycles - 1) of std_logic;

	
	--# Constants
constant internal_clock_period : time := 10.0 ns;

constant sig_CLK_values : clk_std_logic_array := ( '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0');
constant sig_A_values : std_logic_array := ( '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0');
constant sig_B_values : std_logic_array := ( '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0');
constant sig_F_values : std_logic_array := ( '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0');


	--# Timing Signals
signal EndOfSimulation : std_logic := '0';signal internal_clock : std_logic := '1';

		
	--# Clock Signals
    signal sig_CLK : std_logic := sig_CLK_values(0);
	
	--# Input Signals
    signal sig_B : std_logic := sig_B_values(0);
    signal sig_A : std_logic := sig_A_values(0);

	--# Output Signals
    signal sig_F : std_logic := sig_F_values(0);
	
	--# Simulation Signals
signal sig_n : integer := 0;

	
begin
	dut : andGate_timed PORT MAP(
CLK => sig_CLK,
A => sig_A,
B => sig_B,
F => sig_F );


	checker_initiation : checker_init(warning, "", ".warning_log/andgatefull__andgate_full_messages.csv", level, verbose_csv, failure, ',', false);
	warning_logger_initiation : checker_init(warning_logger, warning, "", ".warning_log/andgatefull__andgate_full_result.csv", level, verbose_csv, failure, ',', false);

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

			if run("andgate_full") then
				
				while (n <= clock_cycles - 1) loop


				
				sig_n <= n;

				
				--# Extra Code For Waiting
	
					wait until rising_edge(internal_clock);
sig_CLK <= sig_CLK_values(2*n);
sig_A <= sig_A_values(n);
sig_B <= sig_B_values(n);


					
					
					wait until falling_edge(internal_clock);
sig_CLK <= sig_CLK_values(2*n+1);


					
					
 if sig_F_values(n) /= 'X' then
check(warning_logger,  sig_F = sig_F_values(n), integer'image(error_number) & ",F," & std_logic'image(sig_F_values(n)) & "," &  std_logic'image(sig_F) & "," & integer'image(n) , line_num => error_number);
check(sig_F = sig_F_values(n), integer'image(error_number) & ". This check failed. Expected sig_F =  " & std_logic'image(sig_F_values(n)) & ", got sig_F =  " & std_logic'image(sig_F) & " at n = " & integer'image(n) & "." );
if sig_F /= sig_F_values(n) then
error_number := error_number + 1;
end if;
end if;

	
					n := n+1;
					--# Extra End If For waiting
				end loop;


				
				EndOFSimulation <= '1';

			
			end if;
		end loop;

		test_runner_cleanup(runner);
	end process;
	
	Clk_process : process
begin
if (EndOfSimulation = '0') then
internal_clock <= '1';
wait for internal_clock_period / 2;
internal_clock <= '0';
wait for internal_clock_period - internal_clock_period / 2;
end if;
end process;


end architecture;
---------------------------------------------------------END