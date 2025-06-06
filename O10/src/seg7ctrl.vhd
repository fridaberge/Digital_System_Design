library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.seg7_pkg.all;


entity seg7ctrl is
    generic (N:integer:=1000000); --1mill
    --generic (N:integer:=3);
    port
    (
        mclk      : in std_logic; --100MHz, positive flank
        reset     : in std_logic; --Asynchronous reset, active high
        d0        : in std_logic_vector(3 downto 0);
        d1        : in std_logic_vector(3 downto 0);
        abcdefg   : out std_logic_vector(6 downto 0);
        c         : out std_logic
    );
    end entity seg7ctrl;

architecture rtl of seg7ctrl is
--100MHz/50Hz = 2Mill, 1 mill
--because d0 is active half the time and d1 is active half the time
--need 21 bits to express 2M
signal counter : unsigned(21 downto 0);
begin
    process (mclk, reset) is
    begin
        --the counter follows the clock
        --when it had reached max, it will swith to the other panel
        if rising_edge(mclk) then
            if reset='1' then
                counter <= (others => '0');
                c <= '0';
            elsif counter = N then
                counter <= (others => '0');
                c <= not c;
            else
                counter <= counter + 1;
            end if;
            
        end if;

        
    end process;

    --c <= counter(N-1);

    process(all) is
    begin
        if c='1' then
            abcdefg <= bin2ssd(d1);
        elsif c='0' then
            abcdefg <= bin2ssd(d0);
        end if;
    end process;

end rtl;
  





