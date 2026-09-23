-- 8 bit Register Unit for Lab 6 (latch)
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY SUlatch IS
    PORT ( A      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);  
	 -- 8-bit data input (A or B in storage unit.bdf)
           Clr : IN  STD_LOGIC;                       -- active-low reset
           Clk  : IN  STD_LOGIC;
           Q      : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) );  -- 8-bit output
END SUlatch;

ARCHITECTURE Behavior OF SUlatch IS
BEGIN
    PROCESS (Clr, Clk)
    BEGIN
        IF Clr = '1' THEN -- active-high reset
            Q <= "00000000";
        ELSIF Clk'EVENT AND Clk = '1' THEN
            Q <= A;
        END IF;
    END PROCESS;
END Behavior;

