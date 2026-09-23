-- Combiner

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Combiner IS
    PORT ( X  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
           Z : IN  STD_LOGIC_VECTOR(15 DOWNTO 8);
           Y  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) );
END Combiner;

ARCHITECTURE Behavior OF Combiner IS
BEGIN

	Y <= Z & X; -- MSB's and LSB's anded.

END Behavior;