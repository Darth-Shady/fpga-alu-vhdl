-- Simple upcounter 
library ieee;
use ieee.std_logic_1164.all;

entity machine is
    port ( clk          : in  std_logic;
           reset        : in  std_logic;
           data_in      : in  std_logic;
           student_id   : out std_logic_vector(3 downto 0);
           current_state: out std_logic_vector(3 downto 0) );
end entity;

architecture fsm of machine is
    type state_type is (s0, s1, s2, s3, s4, s5, s6, s7, s8);
    signal yfsm, next_state : state_type;
begin

    -- Combined next-state + Mealy output logic
    -- student_id depends on current state AND data_in
    process (yfsm, data_in)
    begin
        case yfsm is
            when s0 =>
                next_state <= s1;
                if data_in = '1' then student_id <= "0101"; -- 5
                else                  student_id <= "1111"; -- off
                end if;
            when s1 =>
                next_state <= s2;
                if data_in = '1' then student_id <= "0000"; -- 0
                else                  student_id <= "1111";
                end if;
            when s2 =>
                next_state <= s3;
                if data_in = '1' then student_id <= "0001"; -- 1
                else                  student_id <= "1111";
                end if;
            when s3 =>
                next_state <= s4;
                if data_in = '1' then student_id <= "0011"; -- 3
                else                  student_id <= "1111";
                end if;
            when s4 =>
                next_state <= s5;
                if data_in = '1' then student_id <= "0010"; -- 2
                else                  student_id <= "1111";
                end if;
            when s5 =>
                next_state <= s6;
                if data_in = '1' then student_id <= "0010"; -- 2
                else                  student_id <= "1111";
                end if;
            when s6 =>
                next_state <= s7;
                if data_in = '1' then student_id <= "0001"; -- 1
                else                  student_id <= "1111";
                end if;
            when s7 =>
                next_state <= s8;
                if data_in = '1' then student_id <= "0011"; -- 3
                else                  student_id <= "1111";
                end if;
            when s8 =>
                next_state <= s0;
                if data_in = '1' then student_id <= "0100"; -- 4
                else                  student_id <= "1111";
                end if;
            when others =>
                next_state <= s0;
                student_id <= "1111";
        end case;
    end process;

    -- State register
    process (clk, reset)
    begin
        if reset = '1' then
            yfsm <= s0;
        elsif clk'event and clk = '1' then
            yfsm <= next_state;
        end if;
    end process;

    -- current_state output: feeds decoder
    process (yfsm)
    begin
        case yfsm is
            when s0 => current_state <= "0000";
            when s1 => current_state <= "0001";
            when s2 => current_state <= "0010";
            when s3 => current_state <= "0011";
            when s4 => current_state <= "0100";
            when s5 => current_state <= "0101";
            when s6 => current_state <= "0110";
            when s7 => current_state <= "0111";
            when s8 => current_state <= "1000";
            when others => current_state <= "1111";
        end case;
    end process;

end fsm;