-- ---------------------------------------------------
-- Author: 
-- Test name: uart_send_2_bytes_failing
-- Test description: A failing test for sending two consecutive bytes with an parallel to serial uart
-- ---------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_uart_3_send_two_bytes_failing_gen is
	generic(runner_cfg : runner_cfg_t);
end entity;

architecture uart_3_send_two_bytes_failing_generated_testbench of tb_uart_3_send_two_bytes_failing_gen is
	shared variable warning_logger : checker_t;
	COMPONENT uart_tx

		PORT(
clk : in std_logic;
tvalid : in std_logic;
tdata : in std_logic_vector;
tx : out std_logic;
tready : out std_logic );

	END COMPONENT;
	
	--# Clock Cycles
constant clock_cycles : integer := 32;
	
	--# Wait Times
constant amount_of_waits : integer := 2;
	
	--# Relative Period
constant relative_period : integer :=  2;
	
	--# Helper Types
type clk_std_logic_array is array (0 to 2*clock_cycles - 1) of std_logic;
type std_logic_array is array (0 to clock_cycles - 1) of std_logic;
type std_logic_vector_array is array (0 to clock_cycles - 1) of std_logic_vector;

type wait_integer_array is array (0 to amount_of_waits) of integer;
	
	--# Constants
constant internal_clock_period : time := 5.0 ns;

constant sig_clk_values : clk_std_logic_array := ( '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '-', '-', '-', '-', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '-', '-', '-', '-');
constant sig_tvalid_values : std_logic_array := ( '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
constant sig_tdata_values : std_logic_vector_array := ( "00000000", "00000000", "11111001", "11111001", "11111001", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "XXXXXXXX", "XXXXXXXX", "00000000", "01111111", "01111111", "01111111", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "XXXXXXXX", "XXXXXXXX");
constant sig_tx_values : std_logic_array := ( '1', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', 'X', 'X', '1', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', 'X', 'X');
constant sig_tready_values : std_logic_array := ( '0', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', 'X', 'X', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 'X', 'X');

constant wait_array : wait_integer_array := (10*434, 10*434, 0);

	--# Timing Signals
signal EndOfSimulation : std_logic := '0';signal internal_clock : std_logic := '1';

		
	--# Clock Signals
    signal sig_clk : std_logic := sig_clk_values(0);
	
	--# Input Signals
    signal sig_tdata : std_logic_vector(7 downto 0) := sig_tdata_values(0);
    signal sig_tvalid : std_logic := sig_tvalid_values(0);

	--# Output Signals
    signal sig_tready : std_logic := sig_tready_values(0);
    signal sig_tx : std_logic := sig_tx_values(0);
	
	--# Simulation Signals
signal sig_n : integer := 0;

	
begin
	dut : uart_tx PORT MAP(
clk => sig_clk,
tvalid => sig_tvalid,
tdata => sig_tdata,
tx => sig_tx,
tready => sig_tready );


	checker_initiation : checker_init(warning, "", ".warning_log/uart_3_send_two_bytes_failing__uart_send_2_bytes_failing_messages.csv", level, verbose_csv, failure, ',', false);
	warning_logger_initiation : checker_init(warning_logger, warning, "", ".warning_log/uart_3_send_two_bytes_failing__uart_send_2_bytes_failing_result.csv", level, verbose_csv, failure, ',', false);

	main : process
		variable n : integer := 0;
		variable v : integer := 0;
		variable error_number     : integer := 1;
		--# Wait Variables
 variable wait_array_index : integer := 0;variable wait_variable : integer := wait_array(wait_array_index);
		
	begin
		test_runner_setup(runner, runner_cfg);
		
		while test_suite loop
			reset_checker_stat; 
			n := 0;

			if run("uart_send_2_bytes_failing") then
				
				while (n <= clock_cycles - 1) loop


				
				sig_n <= n;

				
				if sig_clk_values(2 * n) = '-' and wait_variable > 0 then 
while wait_variable > 0 loop
v := n mod (relative_period);
while (v - (n mod (relative_period)) < relative_period) loop
wait until rising_edge(internal_clock);
sig_clk <= sig_clk_values(2*v);
sig_tvalid <= sig_tvalid_values(n);
sig_tdata <= sig_tdata_values(n);


wait until falling_edge(internal_clock);
sig_clk <= sig_clk_values(2*v+1);



 if sig_tx_values(n) /= 'X' then
check(warning_logger,  sig_tx = sig_tx_values(n), integer'image(error_number) & ",tx," & std_logic'image(sig_tx_values(n)) & "," &  std_logic'image(sig_tx) & "," & integer'image(n) , line_num => error_number);
check(sig_tx = sig_tx_values(n), integer'image(error_number) & ". This check failed. Expected sig_tx =  " & std_logic'image(sig_tx_values(n)) & ", got sig_tx =  " & std_logic'image(sig_tx) & " at n = " & integer'image(n) & "." );
if sig_tx /= sig_tx_values(n) then
error_number := error_number + 1;
end if;
end if;

 if sig_tready_values(n) /= 'X' then
check(warning_logger,  sig_tready = sig_tready_values(n), integer'image(error_number) & ",tready," & std_logic'image(sig_tready_values(n)) & "," &  std_logic'image(sig_tready) & "," & integer'image(n) , line_num => error_number);
check(sig_tready = sig_tready_values(n), integer'image(error_number) & ". This check failed. Expected sig_tready =  " & std_logic'image(sig_tready_values(n)) & ", got sig_tready =  " & std_logic'image(sig_tready) & " at n = " & integer'image(n) & "." );
if sig_tready /= sig_tready_values(n) then
error_number := error_number + 1;
end if;
end if;

v := v + 1;
end loop;
wait_variable := wait_variable - 1;
end loop;
n := n + relative_period;
wait_array_index := wait_array_index + 1;
wait_variable    := wait_array(wait_array_index);
else
	
					wait until rising_edge(internal_clock);
sig_clk <= sig_clk_values(2*n);
sig_tvalid <= sig_tvalid_values(n);
sig_tdata <= sig_tdata_values(n);


					
					
					wait until falling_edge(internal_clock);
sig_clk <= sig_clk_values(2*n+1);


					
					
 if sig_tx_values(n) /= 'X' then
check(warning_logger,  sig_tx = sig_tx_values(n), integer'image(error_number) & ",tx," & std_logic'image(sig_tx_values(n)) & "," &  std_logic'image(sig_tx) & "," & integer'image(n) , line_num => error_number);
check(sig_tx = sig_tx_values(n), integer'image(error_number) & ". This check failed. Expected sig_tx =  " & std_logic'image(sig_tx_values(n)) & ", got sig_tx =  " & std_logic'image(sig_tx) & " at n = " & integer'image(n) & "." );
if sig_tx /= sig_tx_values(n) then
error_number := error_number + 1;
end if;
end if;

 if sig_tready_values(n) /= 'X' then
check(warning_logger,  sig_tready = sig_tready_values(n), integer'image(error_number) & ",tready," & std_logic'image(sig_tready_values(n)) & "," &  std_logic'image(sig_tready) & "," & integer'image(n) , line_num => error_number);
check(sig_tready = sig_tready_values(n), integer'image(error_number) & ". This check failed. Expected sig_tready =  " & std_logic'image(sig_tready_values(n)) & ", got sig_tready =  " & std_logic'image(sig_tready) & " at n = " & integer'image(n) & "." );
if sig_tready /= sig_tready_values(n) then
error_number := error_number + 1;
end if;
end if;

	
					n := n+1;
					end if;
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