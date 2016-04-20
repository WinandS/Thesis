---------------------------------------------------------
-- Author : http://www.teahlab.com/
--
-- Circuit: AND Gate
--
-- Note   : This VHDL program is a structural description
--         of the interactive AND Gate on teahlab.com.
--
--         If you are new to VHDL, then notice how the
--         program is designed: 1] first we declare the 
--         ENTITY, which is where we define the inputs
--         and the outputs of the circuit. 2] Second
--         we present the ARCHITECTURE, which is where
--         we describe the behavior and function of 
--         the circuit. 
---------------------------------------------------------

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
------------------------------------------------------END
------------------------------------------------------END