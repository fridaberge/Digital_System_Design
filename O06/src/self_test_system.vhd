library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.seg7_pkg.all;


entity self_test_system is 
    port
    (
        mclk      : in std_logic; --100MHz, positive flank
        reset     : in std_logic; --Asynchronous reset, active high
        system_c         : out std_logic;
        system_abcdefg   : out std_logic_vector(6 downto 0)
    );
end entity self_test_system;


architecture rtl of self_test_system is
    signal intermediate0: std_logic_vector(3 downto 0);
    signal intermediate1: std_logic_vector(3 downto 0);

    component self_test_unit is
        port
        (
            mclk      : in std_logic; --100MHz, positive flank
            reset     : in std_logic; --Asynchronous reset, active high
            d0        : out std_logic_vector(3 downto 0);
            d1        : out std_logic_vector(3 downto 0)
        );
    end component;

    component seg7ctrl_arch is
        port
        (
            mclk      : in std_logic; --100MHz, positive flank
            reset     : in std_logic; --Asynchronous reset, active high
            d0        : in std_logic_vector(3 downto 0);
            d1        : in std_logic_vector(3 downto 0);
            abcdefg   : out std_logic_vector(6 downto 0);
            c         : out std_logic
        );
    end component;

begin
    self_test: component self_test_unit
        port map(
            mclk => mclk, --100MHz, positive flank
            reset => reset, --Asynchronous reset, active high
            d0 => intermediate0,
            d1 => intermediate1
        );

    seg7: component seg7ctrl_arch
        port map(
            mclk => mclk,
            reset => reset,
            d0 => intermediate0,
            d1 => intermediate1,
            abcdefg => system_abcdefg,
            c => system_c
        );

end rtl;
    
