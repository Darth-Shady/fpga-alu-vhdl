--ALU3

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY ASU3 IS
    PORT ( Clock      : IN  STD_LOGIC;
           A, B       : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
           OP         : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
           student_id : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
           Neg        : OUT STD_LOGIC;
           R1         : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
           R2         : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
           parity_out : OUT STD_LOGIC );  -- '1' = even parity (y), '0' = odd (n)
END ASU3;

ARCHITECTURE Calculation OF ASU3 IS
    SIGNAL Reg1, Reg2, Result : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL parity             : STD_LOGIC;
BEGIN
    Reg1 <= A;
    Reg2 <= B;

    -- Even parity: XOR all bits; '0' = even number of 1s
    parity <= student_id(3) XOR student_id(2) XOR student_id(1) XOR student_id(0);
    parity_out <= NOT parity;  -- '1' when even parity (display 'y')

    PROCESS (Clock)
        VARIABLE diff : STD_LOGIC_VECTOR(7 DOWNTO 0);
    BEGIN
        IF rising_edge(Clock) THEN
            Neg <= '0';

            CASE OP IS
                WHEN "0000000000000001" =>   -- F1: SHR A by 2, fill with 1
                    Result <= "11" & Reg1(7 DOWNTO 2);

                WHEN "0000000000000010" =>   -- F2: (A - B) + 4
                    diff   := Reg1 - Reg2;
                    Result <= diff + "00000100";
                    IF Reg1 < Reg2 THEN
                        Neg <= '1';
                    END IF;

                WHEN "0000000000000100" =>   -- F3: Max(A, B)
                    IF Reg1 >= Reg2 THEN
                        Result <= Reg1;
                    ELSE
                        Result <= Reg2;
                    END IF;

                WHEN "0000000000001000" =>   -- F4: upper 4 of A replaced by lower 4 of B
                    Result <= Reg2(3 DOWNTO 0) & Reg1(3 DOWNTO 0);

                WHEN "0000000000010000" =>   -- F5: A + 1
                    Result <= Reg1 + "00000001";

                WHEN "0000000000100000" =>   -- F6: A AND B
                    Result <= Reg1 AND Reg2;

                WHEN "0000000001000000" =>   -- F7: invert upper 4 bits of A
                    Result <= (NOT Reg1(7 DOWNTO 4)) & Reg1(3 DOWNTO 0);

                WHEN "0000000010000000" =>   -- F8: ROL B by 3
                    Result <= Reg2(4 DOWNTO 0) & Reg2(7 DOWNTO 5);

                WHEN "0000000100000000" =>   -- F9: null
                    Result <= (OTHERS => '0');

                WHEN OTHERS =>
                    Result <= (OTHERS => '0');
            END CASE;
        END IF;
    END PROCESS;

    R1 <= Result(3 DOWNTO 0);
    R2 <= Result(7 DOWNTO 4);

END Calculation;