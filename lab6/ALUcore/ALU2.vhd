-- ALU2

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY ALU2 IS
    PORT ( Clock : IN  STD_LOGIC;
           A, B  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
           OP    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
           Neg   : OUT STD_LOGIC;
           R1    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
           R2    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) );
END ALU2;

ARCHITECTURE Calculation OF ALU2 IS
    SIGNAL Reg1, Reg2, Result : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
BEGIN
    Reg1 <= A;
    Reg2 <= B;

    PROCESS (Clock)
        VARIABLE diff : STD_LOGIC_VECTOR(7 DOWNTO 0);
    BEGIN
        IF rising_edge(Clock) THEN
            Neg <= '0';

            CASE OP IS

                -- F1: Shift A right by 2, fill MSBs with 1
                WHEN "0000000000000001" =>
                    Result <= "11" & Reg1(7 DOWNTO 2);

                -- F2: (A - B) + 4
                WHEN "0000000000000010" =>
                    diff   := Reg1 - Reg2;
                    Result <= diff + "00000100";
                    IF Reg1 < Reg2 THEN
                        Neg <= '1';
                    END IF;

                -- F3: Max(A, B)
                WHEN "0000000000000100" =>
                    IF Reg1 >= Reg2 THEN
                        Result <= Reg1;
                    ELSE
                        Result <= Reg2;
                    END IF;

                -- F4: Replace upper 4 bits of A with lower 4 bits of B
                WHEN "0000000000001000" =>
                    Result <= Reg2(3 DOWNTO 0) & Reg1(3 DOWNTO 0);

                -- F5: A + 1
                WHEN "0000000000010000" =>
                    Result <= Reg1 + "00000001";

                -- F6: A AND B
                WHEN "0000000000100000" =>
                    Result <= Reg1 AND Reg2;

                -- F7: Invert upper 4 bits of A
                WHEN "0000000001000000" =>
                    Result <= (NOT Reg1(7 DOWNTO 4)) & Reg1(3 DOWNTO 0);

                -- F8: Rotate B left by 3
                WHEN "0000000010000000" =>
                    Result <= Reg2(4 DOWNTO 0) & Reg2(7 DOWNTO 5);

                -- F9: Null
                WHEN "0000000100000000" =>
                    Result <= (OTHERS => '0');

                WHEN OTHERS =>
                    Result <= (OTHERS => '0');

            END CASE;
        END IF;
    END PROCESS;

    R1 <= Result(3 DOWNTO 0);
    R2 <= Result(7 DOWNTO 4);

END Calculation;