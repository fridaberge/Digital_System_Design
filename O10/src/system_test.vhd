library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity system_test is
    generic 
    (
        data_size: natural := 8; --8 bits at each address
        num_values: natural := 20 --20 values
    ); 

    port(
        mclk, reset : in std_logic;
        duty_cycle  : in std_logic_vector(7 downto 0);
        dir, en     : out std_logic
    ); 
end entity system_test;

architecture structural of system_test is

    component pwm2 is
        port(
            mclk, reset : in std_logic;
            duty_cycle  : in std_logic_vector(7 downto 0);
            dir, en     : out std_logic 
        );
    end component;

    component output_synch is
        port(
            mclk, reset, dir_async, en_async : in std_logic;
            dir_sync, en_sync     : out std_logic
        );
    end component;

    signal dir_sig  :std_logic;
    signal en_sig   :std_logic;

begin


    pwm: component pwm2
        port map(
            mclk => mclk,
            reset => reset,
            duty_cycle => duty_cycle,
            dir => dir_sig, --output
            en => en_sig --output
        );

    out_sync: component output_synch
        port map(
            mclk => mclk,
            reset => reset,
            dir_async => dir_sig,
            en_async => en_sig,
            dir_sync => dir, --output
            en_sync => en --output
        );


end architecture;



