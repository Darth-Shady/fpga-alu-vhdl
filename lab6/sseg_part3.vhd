--sseg ALU3

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY sseg_modified IS
    PORT ( bcd        : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
           parity_in  : IN  STD_LOGIC;  -- '1' = even = 'y', '0' = odd = 'n'
           leds       : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) );
END sseg_modified;

ARCHITECTURE Behavior OF sseg_modified IS
BEGIN
    PROCESS(bcd, parity_in)
    BEGIN
        IF parity_in = '1' THEN
            leds <= "1000100";  -- 'y' on 7-seg (segments: a,b,c,d,e,f,g = active low)
        ELSE
            leds <=  "1101010";  -- 'n' on 7-seg
        END IF;
    END PROCESS;
END Behavior;