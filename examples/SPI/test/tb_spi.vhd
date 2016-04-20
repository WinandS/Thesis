-- ---------------------------------------------------
-- Author: 
-- Test name: SPI_send_one_byte
-- Test description: A test for an SPI master sending one byte over an SPI connection
-- ---------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_spi_gen is
	generic(runner_cfg : runner_cfg_t);
end entity;

architecture spi_generated_testbench of tb_spi_gen is
	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT SPI_Master
		PORT(
			clk      : in  std_logic;
			TX_Data  : in  std_logic_vector;
			MISO     : in  std_logic;
			TX_Start : in  std_logic;
			RX_Data  : out std_logic_vector;
			MOSI     : out std_logic;
			SCLK     : out std_logic;
			SS       : out std_logic;
			TX_Done  : out std_logic);

	END COMPONENT;

	--# Clock Cycles
	constant clock_cycles : integer := 60;

	--# Wait Times
	constant amount_of_waits : integer := 18;

	--# Relative Period
	constant relative_period : integer := 2;

	--# Helper Types
	type clk_std_logic_array is array (0 to 2 * clock_cycles - 1) of std_logic;
	type std_logic_vector_array is array (0 to clock_cycles - 1) of std_logic_vector;
	type std_logic_array is array (0 to clock_cycles - 1) of std_logic;

	type wait_integer_array is array (0 to amount_of_waits) of integer;

	--# Constants
	constant internal_clock_period : time := 10.0 ns;

	constant sig_clk_values : clk_std_logic_array := ('1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '-', '-', '-', '-', '1', '1', '0', '0', '1', '1', '0', '0', '-', '-', '-', '-', '-', '-', '-', '-', '1', '1', '0', '0', '1', '1', '0', '0', '-', '-', '-', '-', '-', '-', '-', '-', '-',
		                                              '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '1', '1', '0', '0', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '1', '1', '0', '0',
		                                              '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0');
	constant sig_TX_Data_values : std_logic_vector_array := ("01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110",
		                                                     "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110",
		                                                     "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110", "01111110");
	constant sig_MISO_values : std_logic_array := ('0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',
		                                           '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
	constant sig_TX_Start_values : std_logic_array := ('0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1',
		                                               '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0');
	constant sig_RX_Data_values : std_logic_vector_array := ("00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000",
		                                                     "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000",
		                                                     "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000");
	constant sig_MOSI_values : std_logic_array := ('0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '0', '0',
		                                           '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
	constant sig_SCLK_values : std_logic_array := ('X', 'X', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '0', '0', '0', '0', '1', '1',
		                                           '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
	constant sig_SS_values : std_logic_array := ('X', 'X', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',
		                                         '0', '0', '0', '0', '1', '1', '1', '1', '1', '1');
	constant sig_TX_Done_values : std_logic_array := ('X', 'X', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',
		                                              '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0');

	constant wait_array : wait_integer_array := (150, 25, 24, 24, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 24, 25, 25, 0);

	--# Timing Signals
	signal EndOfSimulation : std_logic := '0';
	signal internal_clock  : std_logic := '1';

	--# Clock Signals
	signal sig_clk : std_logic := sig_clk_values(0);

	--# Input Signals
	signal sig_TX_Start : std_logic                    := sig_TX_Start_values(0);
	signal sig_MISO     : std_logic                    := sig_MISO_values(0);
	signal sig_TX_Data  : std_logic_vector(7 downto 0) := sig_TX_Data_values(0);

	--# Output Signals
	signal sig_TX_Done : std_logic                    := sig_TX_Done_values(0);
	signal sig_SS      : std_logic                    := sig_SS_values(0);
	signal sig_SCLK    : std_logic                    := sig_SCLK_values(0);
	signal sig_MOSI    : std_logic                    := sig_MOSI_values(0);
	signal sig_RX_Data : std_logic_vector(7 downto 0) := sig_RX_Data_values(0);

	--# Simulation Signals
	signal sig_n : integer := 0;

begin
	dut : SPI_Master PORT MAP(
			clk      => sig_clk,
			TX_Data  => sig_TX_Data,
			MISO     => sig_MISO,
			TX_Start => sig_TX_Start,
			RX_Data  => sig_RX_Data,
			MOSI     => sig_MOSI,
			SCLK     => sig_SCLK,
			SS       => sig_SS,
			TX_Done  => sig_TX_Done);

	checker_initiation : checker_init(warning, "", "vunit_out/error.csv", level, off, failure, ',', false);

	main : process
		variable n                : integer := 0;
		variable v                : integer := 0;
		--# Wait Variables
		variable wait_array_index : integer := 0;
		variable wait_variable    : integer := wait_array(wait_array_index);

	begin
		test_runner_setup(runner, runner_cfg);

		while test_suite loop
			reset_checker_stat;
			n := 0;

			if run("SPI_send_one_byte") then
				while (n <= clock_cycles - 1) loop
					sig_n <= n;

					if sig_clk_values(2 * n) = '-' and wait_variable > 0 then
						while wait_variable > 0 loop
							v := n mod (relative_period);
							while (v - (n mod (relative_period)) < relative_period) loop
								wait until rising_edge(internal_clock);
								sig_clk      <= sig_clk_values(2 * v);
								sig_TX_Data  <= sig_TX_Data_values(n);
								sig_MISO     <= sig_MISO_values(n);
								sig_TX_Start <= sig_TX_Start_values(n);

								wait until falling_edge(internal_clock);
								sig_clk <= sig_clk_values(2 * v + 1);

								if sig_RX_Data_values(n)(0) /= 'X' then
									check(sig_RX_Data = sig_RX_Data_values(n), "Woops");
								end if; -- Do some check for a vector 

								if sig_MOSI_values(n) /= 'X' then
									check(sig_MOSI = sig_MOSI_values(n), "this check failed. Expected MOSI = " & std_logic'image(sig_MOSI_values(n)) & ", got MOSI = " & std_logic'image(sig_MOSI) & " at n = " & integer'image(n) & ".");
								end if;
								if sig_SCLK_values(n) /= 'X' then
									check(sig_SCLK = sig_SCLK_values(n), "this check failed. Expected SCLK = " & std_logic'image(sig_SCLK_values(n)) & ", got SCLK = " & std_logic'image(sig_SCLK) & " at n = " & integer'image(n) & ".");
								end if;
								if sig_SS_values(n) /= 'X' then
									check(sig_SS = sig_SS_values(n), "this check failed. Expected SS = " & std_logic'image(sig_SS_values(n)) & ", got SS = " & std_logic'image(sig_SS) & " at n = " & integer'image(n) & ".");
								end if;
								if sig_TX_Done_values(n) /= 'X' then
									check(sig_TX_Done = sig_TX_Done_values(n), "this check failed. Expected TX_Done = " & std_logic'image(sig_TX_Done_values(n)) & ", got TX_Done = " & std_logic'image(sig_TX_Done) & " at n = " & integer'image(n) & ".");
								end if;
								v := v + 1;
							end loop;
							wait_variable := wait_variable - 1;
						end loop;
						n                := n + relative_period;
						wait_array_index := wait_array_index + 1;
						wait_variable    := wait_array(wait_array_index);
					else
						wait until rising_edge(internal_clock);
						sig_clk      <= sig_clk_values(2 * n);
						sig_TX_Data  <= sig_TX_Data_values(n);
						sig_MISO     <= sig_MISO_values(n);
						sig_TX_Start <= sig_TX_Start_values(n);

						wait until falling_edge(internal_clock);
						sig_clk <= sig_clk_values(2 * n + 1);

						if sig_RX_Data_values(n)(0) /= 'X' then
							check(sig_RX_Data = sig_RX_Data_values(n), "Woops");
						end if;         -- Do some check for a vector 

						if sig_MOSI_values(n) /= 'X' then
							check(sig_MOSI = sig_MOSI_values(n), "this check failed. Expected MOSI = " & std_logic'image(sig_MOSI_values(n)) & ", got MOSI = " & std_logic'image(sig_MOSI) & " at n = " & integer'image(n) & ".");
						end if;
						if sig_SCLK_values(n) /= 'X' then
							check(sig_SCLK = sig_SCLK_values(n), "this check failed. Expected SCLK = " & std_logic'image(sig_SCLK_values(n)) & ", got SCLK = " & std_logic'image(sig_SCLK) & " at n = " & integer'image(n) & ".");
						end if;
						if sig_SS_values(n) /= 'X' then
							check(sig_SS = sig_SS_values(n), "this check failed. Expected SS = " & std_logic'image(sig_SS_values(n)) & ", got SS = " & std_logic'image(sig_SS) & " at n = " & integer'image(n) & ".");
						end if;
						if sig_TX_Done_values(n) /= 'X' then
							check(sig_TX_Done = sig_TX_Done_values(n), "this check failed. Expected TX_Done = " & std_logic'image(sig_TX_Done_values(n)) & ", got TX_Done = " & std_logic'image(sig_TX_Done) & " at n = " & integer'image(n) & ".");
						end if;

						n := n + 1;
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