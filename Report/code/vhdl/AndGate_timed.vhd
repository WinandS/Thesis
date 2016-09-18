library ieee;
use ieee.std_logic_1164.all;


entity andGate_timed is
	port(A, B, CLK : in  std_logic;
		 Q         : out std_logic := '0');
end andGate_timed;


architecture RTL of andGate_timed is
begin
	process(CLK)
	begin
		if rising_edge(CLK) then
			Q <= A and B;
		end if;
	end process;
end RTL;