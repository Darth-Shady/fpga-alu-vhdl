LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY ALU3 IS
    PORT ( Clk        : IN  STD_LOGIC;
           A, B       : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
           Op         : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
           student_id : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
           Result     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
           parity_out : OUT STD_LOGIC );
END ALU3;

ARCHITECTURE Calculation OF ALU3 IS
    SIGNAL Res : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
BEGIN

    parity_out <= NOT (student_id(3) XOR student_id(2) XOR student_id(1) XOR student_id(0));

    PROCESS (Clk)
        VARIABLE diff : STD_LOGIC_VECTOR(7 DOWNTO 0);
    BEGIN
        IF rising_edge(Clk) THEN
            CASE Op IS
                WHEN "0000000000000001" =>   -- F1: SHR A by 2, fill with 1
                    Res <= "11" & A(7 DOWNTO 2);
                WHEN "0000000000000010" =>   -- F2: (A - B) + 4
                    diff := A - B;
                    Res  <= diff + "00000100";
                WHEN "0000000000000100" =>   -- F3: Max(A, B)
                    IF A >= B THEN Res <= A;
                    ELSE            Res <= B;
                    END IF;
                WHEN "0000000000001000" =>   -- F4: upper 4 of A replaced by lower 4 of B
                    Res <= B(3 DOWNTO 0) & A(3 DOWNTO 0);
                WHEN "0000000000010000" =>   -- F5: A + 1
                    Res <= A + "00000001";
                WHEN "0000000000100000" =>   -- F6: A AND B
                    Res <= A AND B;
                WHEN "0000000001000000" =>   -- F7: invert upper 4 bits of A
                    Res <= (NOT A(7 DOWNTO 4)) & A(3 DOWNTO 0);
                WHEN "0000000010000000" =>   -- F8: ROL B by 3
                    Res <= B(4 DOWNTO 0) & B(7 DOWNTO 5);
                WHEN "0000000100000000" =>   -- F9: null
                    Res <= (OTHERS => '0');
                WHEN OTHERS =>
                    Res <= (OTHERS => '0');
            END CASE;
        END IF;
    END PROCESS;

    Result <= Res(3 DOWNTO 0);

END Calculation;