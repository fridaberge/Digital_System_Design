library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity input_synch is

    port(
        mclk, reset, a, b : in std_logic;
        a_synch, b_synch  : out std_logic
    );
end entity input_synch;

architecture rtl of input_synch is

    signal r_a, r_b: std_logic:= '0';
begin

    process(mclk)
    begin
        if rising_edge(mclk) then
            if reset = '1' then
                r_a <= '0';
                r_b <= '0';
            else
                r_a <= a;
                r_b <= b;
            end if;
        end if;
    end process;

    a_synch <= r_a;
    b_synch <= r_b;


end architecture rtl;