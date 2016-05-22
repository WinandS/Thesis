--import std_logic from the IEEE library
library ieee;
use ieee.std_logic_1164.all;

--ENTITY DECLARATION: name, inputs, outputs
entity andGate is					
   port( A, B : in std_logic;
            F : out std_logic);
end andGate;

--FUNCTIONAL DESCRIPTION: how the AND Gate works
architecture func of andGate is 
begin
  F <= A and B;		
end func;