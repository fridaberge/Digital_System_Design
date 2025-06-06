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
        --address     : in std_ulogic_vector(num_values-1 downto 0);
        dir, en     : out std_logic
    ); 
end entity system_test;

architecture structural of system_test is

    component self_test is
        port(
            --address : in std_ulogic_vector(num_values-1 downto 0);
            data    : out std_ulogic_vector(data_size-1 downto 0);
            clk     : in std_logic;
            reset   : in std_logic;
            change  : out integer
        );
    end component;

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

    signal outdata  :std_ulogic_vector(data_size-1 downto 0);
    signal dir_sig  :std_logic;
    signal en_sig   :std_logic;
    signal change   :integer := 0;

begin

    st: component self_test
        port map(
            --address => address,
            data => outdata, --output
            clk => mclk,
            reset => reset,
            change => change --output
        );

    pwm: component pwm2
        port map(
            mclk => mclk,
            reset => reset,
            duty_cycle => outdata,
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



