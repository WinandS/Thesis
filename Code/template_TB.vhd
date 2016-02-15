--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:
-- Design Name:   
-- Module Name:   
-- Project Name:  
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- Dependencies:
-- 
-- Revision:
-- 
-- Additional Comments:
--
-- Notes: 
-- 
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY device IS
END device;
 
ARCHITECTURE behavior OF device IS 
 
    --# Component Declaration for the Unit Under Test (UUT)
 
    component device
    port(
			-- TODO: generate port list

--/          Clk : IN  std_logic;	 /--
--/          Rst : IN  std_logic;	 /--
--/          Sclk : IN  std_logic;	 /--
--/          output : OUT  std_logic	 /--
        );
    end component;
    
	--# Inputs
	-- TODO: generate input signal list
   
--/   signal Clk : std_logic := '0';	/--
--/   signal Rst : std_logic := '0';	/--
--/   signal input : std_logic := '0';	/--

	--# Outputs
	-- TODO: generate output signal list
 	
--/   signal output : std_logic;		/--
   
   --# Constants
   -- TODO: generate constant list
   
--/   constant Clk_period : time := 20 ns; -- 50MHz	/--

	--# Variables
	-- TODO: generate variable list
	
	--# Procedures
	-- TODO: generate variable list	

BEGIN
 
	--# Instantiate the Unit Under Test (UUT)
	uut: device PORT MAP (
			-- TODO: connect ports and signals
		);
        
    --# Generate clock
	Clk_process :process
	begin
--/		Clk <= '0';					/--
--/		wait for Clk_period/2;				/--
--/		Clk <= '1';					/--
--/		wait for Clk_period - Clk_period/2;		/--
end process;

	--# Stimulate UUT
	stim_proc: process
	begin		
--/		wait for 100 ns;		/--
--/		rst <= '1'; 			/--
--/		wait for 100 ns;		/--
--/		rst <= '0';				/--
--/								/--
--/		wait for 141.501 ms;	/--
--/		rst <= '1';				/--
--/		wait for 10 ns;			/--
--/		rst <= '0';				/--
--/     						/--
		wait;
   end process;
    
END;

