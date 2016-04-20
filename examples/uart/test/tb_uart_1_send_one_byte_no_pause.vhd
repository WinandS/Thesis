-- ---------------------------------------------------
-- Author: 
-- Test name: uart_send_1_byte_no_wait
-- Test description: A test for sending one byte with an parallel to serial uart (actual sending over tx excluded)
-- ---------------------------------------------------
--import std_logic from the IEEE library
library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_uart_1_send_one_byte_no_pause_gen is
	generic(runner_cfg : runner_cfg_t);
end entity;

architecture uart_1_send_one_byte_no_pause_generated_testbench of tb_uart_1_send_one_byte_no_pause_gen is
	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT uart_tx
		PORT(
			clk    : in  std_logic;
			tvalid : in  std_logic;
			tdata  : in  std_logic_vector;
			tx     : out std_logic;
			tready : out std_logic);

	END COMPONENT;

	--# Clock Cycles
	constant clock_cycles : integer := 16;

	--# Wait Times

	--# Relative Period

	--# Helper Types
	type clk_std_logic_array is array (0 to 2 * clock_cycles - 1) of std_logic;
	type std_logic_array is array (0 to clock_cycles - 1) of std_logic;
	type std_logic_vector_array is array (0 to clock_cycles - 1) of std_logic_vector;

	--# Constants
	constant internal_clock_period : time := 10.0 ns;

	constant sig_clk_values    : clk_std_logic_array    := ('0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1');
	constant sig_tvalid_values : std_logic_array        := ('0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
	constant sig_tdata_values  : std_logic_vector_array := ("00000000", "00000000", "11111001", "11111001", "11111001", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000");
	constant sig_tx_values     : std_logic_array        := ('1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
	constant sig_tready_values : std_logic_array        := ('0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

	--# Timing Signals
	signal EndOfSimulation : std_logic := '0';
	signal internal_clock  : std_logic := '1';

	--# Clock Signals
	signal sig_clk : std_logic := sig_clk_values(0);

	--# Input Signals
	signal sig_tdata  : std_logic_vector(7 downto 0) := sig_tdata_values(0);
	signal sig_tvalid : std_logic                    := sig_tvalid_values(0);

	--# Output Signals
	signal sig_tready : std_logic := sig_tready_values(0);
	signal sig_tx     : std_logic := sig_tx_values(0);

	--# Simulation Signals
	signal sig_n : integer := 0;

begin
	dut : uart_tx PORT MAP(
			clk    => sig_clk,
			tvalid => sig_tvalid,
			tdata  => sig_tdata,
			tx     => sig_tx,
			tready => sig_tready);

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

			if run("uart_send_1_byte_no_wait") then
				while (n <= clock_cycles - 1) loop
					sig_n <= n;

					--# Extra Code For Waiting

					wait until rising_edge(internal_clock);
					sig_clk    <= sig_clk_values(2 * n);
					sig_tvalid <= sig_tvalid_values(n);
					sig_tdata  <= sig_tdata_values(n);

					wait until falling_edge(internal_clock);
					sig_clk <= sig_clk_values(2 * n + 1);

					if sig_tx_values(n) /= 'X' then
						check(sig_tx = sig_tx_values(n), "this check failed. Expected tx = " & std_logic'image(sig_tx_values(n)) & ", got tx = " & std_logic'image(sig_tx) & " at n = " & integer'image(n) & ".");
					end if;
					if sig_tready_values(n) /= 'X' then
						check(sig_tready = sig_tready_values(n), "this check failed. Expected tready = " & std_logic'image(sig_tready_values(n)) & ", got tready = " & std_logic'image(sig_tready) & " at n = " & integer'image(n) & ".");
					end if;

					n := n + 1;
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