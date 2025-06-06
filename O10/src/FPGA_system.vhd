library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FPGA_system is
    generic(
            data_size: natural := 8; --8 bits at each address
            num_values: natural := 20 --20 values
        ); 
    
    port(
        mclk, reset         : in std_logic;
        duty_cycle          : in std_logic_vector(7 downto 0);
        SA, SB              : in std_logic;
        abcdefg             : out std_logic_vector(6 downto 0);
        c, dir, en          : out std_logic;
        velocity            : out signed(7 downto 0)
    );
end entity FPGA_system;

architecture rtl of FPGA_system is

    
    component system_test is
        port(
            mclk, reset : in std_logic;
            duty_cycle  : in std_logic_vector(7 downto 0);
            dir, en     : out std_logic
        );
    end component;


    component system_quad is
        port(
            mclk, reset, a, b : in std_logic;
            abcdefg           : out std_logic_vector(6 downto 0);
            c                 : out std_logic;
            velocity          : out signed(7 downto 0)
        );
    end component;


begin


    sys_test: component system_test
    port map(
        mclk => mclk,
        reset => reset,
        duty_cycle => duty_cycle,
        dir => dir, --output
        en => en --output
    );

    sys_quad: component system_quad
    port map(
        mclk => mclk,
        reset => reset,
        a => SA,
        b => SB,
        abcdefg => abcdefg,
        c => c,
        velocity => velocity --output
    );

end architecture rtl;

