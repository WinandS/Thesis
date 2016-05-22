--import std_logic from the IEEE library
library ieee;
use ieee.std_logic_1164.all;

--ENTITY DECLARATION: name, inputs, outputs
entity andGate_timed is
	port(A, B, CLK : in  std_logic;
		 F         : out std_logic := '0');
end andGate_timed;

--FUNCTIONAL DESCRIPTION: how the AND Gate works
architecture func of andGate_timed is
begin
	process(CLK)
	begin
		if rising_edge(CLK) then
			F <= A and B;
		end if;
	end process;
end func;