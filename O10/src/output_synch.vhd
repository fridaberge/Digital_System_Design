library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity output_synch is

    port(
        mclk, reset, dir_async, en_async : in std_logic;
        dir_sync, en_sync     : out std_logic
    );
end entity output_synch;

architecture rtl of output_synch is

    signal r_dir, r_en: std_logic:= '0'; 
begin

    process(mclk)
    begin
        if rising_edge(mclk) then
            if reset = '1' then
                r_dir <= '0';
                r_en <= '0';
            else
                r_dir <= dir_async;
                r_en <= en_async;
            end if;
        end if;
    end process;

    dir_sync <= r_dir;
    en_sync <= r_en;

end architecture rtl;