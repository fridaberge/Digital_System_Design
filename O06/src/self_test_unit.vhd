library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.seg7_pkg.all;


entity self_test_unit is
    generic ( 
        M:integer:=100000000; --100M
        data_height: natural := 16;
        data_width: natural := 8); 
    port
    (
        mclk      : in std_logic; --100MHz, positive flank
        reset     : in std_logic; --Asynchronous reset, active high
        d0        : out std_logic_vector(3 downto 0);
        d1        : out std_logic_vector(3 downto 0)
    );
end entity self_test_unit;


architecture rtl of self_test_unit is
signal second_counter: unsigned(26 downto 0):= (others => '0'); --27 bits to display 100M
signal second_tick: integer := 0;
signal next_addr: integer := 0;

type memory_array is array(data_height-1 downto 0) of
    std_ulogic_vector(data_width-1 downto 0);


--should have been in its own file according to illustration
constant ROM: memory_array := (
    x"12", --Address 16
    x"34", --address 15
    x"40",
    x"00",
    x"56",
    x"73",
    x"00",
    x"86",
    x"90",
    x"00",
    x"AB",
    x"30",
    x"00",
    x"C6",
    x"65",
    x"00" --address 0
);

begin
    process (mclk, reset) is
    begin
        if rising_edge(mclk) then
            if second_counter = M then
                second_counter <= (others => '0');
                second_tick <= integer(1);
                d1 <= ROM(15-next_addr)(7 downto 4);
                d0 <= ROM(15-next_addr)(3 downto 0);
                if next_addr = data_height-1 then
                    next_addr <= 0;
                else
                    next_addr <= next_addr +1;
                end if;
            else
                second_counter <= second_counter + 1;
                second_tick <= integer(0);
            end if;

        end if;

        --reset is asynchronous
        if reset='1' then
            second_counter <= (others => '0');
            second_tick <= integer(0);
            next_addr <= 0;
            d1 <= ROM(0)(7 downto 4);
            d0 <= ROM(0)(3 downto 0);
        end if;

    end process;

end rtl;
  





