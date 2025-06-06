library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity quad is

    port(
        SA, SB, mclk, reset   : in std_logic;
        POS_INC, POS_DEC      : out std_logic
    );
end entity quad;

architecture rtl of quad is
    
    type statetype is (s_0, s_1, s_2, s_3);
    signal r_state, next_state : statetype;
    signal AB: std_logic_vector(1 downto 0) := "00";
    signal err: std_logic := '0'; 
    -- signal POS_INC, POS_DEC: std_logic;

begin

    process(mclk, reset) is
    begin
        if rising_edge(mclk) then 
            if reset = '1' then
                r_state <= s_0;
                AB <= "00";
            else 
                r_state <= next_state;
            end if;
            AB <= SA & SB;
        end if;
    end process;

    

    STATE_TRANSITIONS: process(all) is
    begin
        err <= '0';
        next_state <= r_state;
        case r_state is
            when s_0 =>
                next_state <=
                    s_0 when AB = "00" else
                    s_1 when AB = "01" else
                    s_3 when AB = "10";
                err <= 
                    '1' when AB = "11";
            when s_1 =>
                next_state <=
                    s_0 when AB = "00" else
                    s_1 when AB = "01" else
                    s_2 when AB = "11";
                err <= 
                    '1' when AB = "10";
            when s_2 =>
                next_state <=
                    s_1 when AB = "01" else
                    s_2 when AB = "11" else
                    s_3 when AB = "10";
                err <= 
                    '1' when AB = "00";
            when s_3 =>
                next_state <=
                    s_0 when AB = "00" else
                    s_2 when AB = "11" else
                    s_3 when AB = "10";
                err <= 
                    '1' when AB = "01";
        end case;
    end process;


    STATE_OUTPUT: process(all) is
    begin

        POS_DEC <= '0';
        POS_INC <= '0';

    
        case r_state is
            when s_0 =>
                POS_DEC <= '1' when next_state = s_3; 
                POS_INC <= '1' when next_state = s_1;
            when s_1 =>
                POS_DEC <= '1' when next_state = s_0;
                POS_INC <= '1' when next_state = s_2;
            when s_2 =>
                POS_DEC <= '1' when next_state = s_1;
                POS_INC <= '1' when next_state = s_3;
            when s_3 =>
                POS_DEC <= '1' when next_state = s_2;
                POS_INC <= '1' when next_state = s_0;
        end case;
    end process;


end architecture rtl;

