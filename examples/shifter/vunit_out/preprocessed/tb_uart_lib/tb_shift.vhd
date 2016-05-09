-- ---------------------------------------------------
-- Author: 
-- Test name: random_shift
-- Test description: A test for shifting a random sequence through a shift register
-- ---------------------------------------------------
--import std_logic from the IEEE library
library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_shift_gen is
	generic(runner_cfg : runner_cfg_t);
end entity;

architecture shift_generated_testbench of tb_shift_gen is
	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT shift_reg

		PORT(
clock : in std_logic;
I : in std_logic;
shift : in std_logic;
Q : out std_logic );

	END COMPONENT;
	
	--# Clock Cycles
constant clock_cycles : integer := 20;
	
	--# Wait Times
	
	--# Relative Period
	
	--# Helper Types
type clk_std_logic_array is array (0 to 2*clock_cycles - 1) of std_logic;
type std_logic_array is array (0 to clock_cycles - 1) of std_logic;

	
	--# Constants
constant internal_clock_period : time := 10.0 ns;

constant sig_clock_values : clk_std_logic_array := ( '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1');
constant sig_I_values : std_logic_array := ( '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '1', '1', '1', '1');
constant sig_shift_values : std_logic_array := ( '0', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
constant sig_Q_values : std_logic_array := ( '1', '1', '1', '1', '1', '1', '1', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '1', '1', '1');


	--# Timing Signals
signal EndOfSimulation : std_logic := '0';signal internal_clock : std_logic := '1';

		
	--# Clock Signals
    signal sig_clock : std_logic := sig_clock_values(0);
	
	--# Input Signals
    signal sig_shift : std_logic := sig_shift_values(0);
    signal sig_I : std_logic := sig_I_values(0);

	--# Output Signals
    signal sig_Q : std_logic := sig_Q_values(0);
	
	--# Simulation Signals
signal sig_n : integer := 0;

	

begin
	dut : shift_reg PORT MAP(
clock => sig_clock,
I => sig_I,
shift => sig_shift,
Q => sig_Q );


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

			if run("random_shift") then
				
				while (n <= clock_cycles - 1) loop


				
				sig_n <= n;

				
				--# Extra Code For Waiting
	
					wait until rising_edge(internal_clock);
sig_clock <= sig_clock_values(2*n);
sig_I <= sig_I_values(n);
sig_shift <= sig_shift_values(n);


					
					
					wait until falling_edge(internal_clock);
sig_clock <= sig_clock_values(2*n+1);


					
					
 if sig_Q_values(n) /= 'X' then
check( sig_Q = sig_Q_values(n), "this check failed. Expected Q = " & std_logic'image(sig_Q_values(n)) & ", got Q = "& std_logic'image(sig_Q) & " at n = " & integer'image(n) & ".", line_num => 117, file_name => "tb_shift.vhd");
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