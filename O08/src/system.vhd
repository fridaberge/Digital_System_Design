library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity system is
    generic(
            data_size: natural := 8; --8 bits at each address
            num_values: natural := 20 --20 values
        ); 
    
    port(
        mclk, reset : in std_logic;
        -- address     : in std_ulogic_vector(num_values-1 downto 0);
        abcdefg     : out std_logic_vector(6 downto 0);
        c, dir, en, a, b           : out std_logic
    );
end entity system;

architecture rtl of system is

    
    component system_test is
        port(
            mclk, reset : in std_logic;
            --address     : in std_ulogic_vector(num_values-1 downto 0);
            dir, en     : out std_logic
        );
    end component;


    component system_quad is
        port(
            mclk, reset, a, b : in std_logic;
            abcdefg           : out std_logic_vector(6 downto 0);
            c                 : out std_logic
        );
    end component;

    --signal dir_sig, en_sig: std_logic:= '0';
    --signal address     :  std_ulogic_vector(num_values-1 downto 0);
begin


    sys_test: component system_test
    port map(
        mclk => mclk,
        reset => reset,
        --address => address,
        dir => dir, --output
        en => en --output
    );

    sys_quad: component system_quad
    port map(
        mclk => mclk,
        reset => reset,
        a => a, --output
        b => b, --output
        abcdefg => abcdefg,
        c => c
    );

end architecture rtl;

