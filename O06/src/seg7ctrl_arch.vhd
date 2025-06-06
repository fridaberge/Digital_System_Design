library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.seg7_pkg.all;


entity seg7ctrl_arch is
    generic (N:integer:=1000000); --1mill
    port
    (
        mclk      : in std_logic; --100MHz, positive flank
        reset     : in std_logic; --Asynchronous reset, active high
        d0        : in std_logic_vector(3 downto 0);
        d1        : in std_logic_vector(3 downto 0);
        abcdefg   : out std_logic_vector(6 downto 0);
        c         : out std_logic
    );
    end entity seg7ctrl_arch;

architecture rtl of seg7ctrl_arch is
--100MHz/50Hz = 2Mill, 1 mill on each display
--because d0 is active half the time and d1 is active half the time
--need 20 bits to express 1M
signal counter : unsigned(20 downto 0); --20
begin
    process (mclk, reset) is
    begin
        --the counter follows the clock
        --when it had reached max, it will swith to the other panel
        if rising_edge(mclk) then

            if counter = N then
                counter <= (others => '0');
                c <= not c;
            else
                counter <= counter + 1;
            end if;
        end if;

        --reset is asynchronous
        if reset='1' then
            counter <= (others => '0');
        end if;
    end process;

    process(c,d0,d1) is
    begin
        if c='1' then
            abcdefg <= bin2ssd_alt(d1);
        elsif c='0' then
            abcdefg <= bin2ssd_alt(d0);
        end if;
    end process;

end rtl;
  





