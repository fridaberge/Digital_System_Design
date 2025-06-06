library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity system_quad is
    port(
        mclk, reset, a, b : in std_logic;
        abcdefg           : out std_logic_vector(6 downto 0);
        c                 : out std_logic
    );
    
end entity system_quad;

architecture rtl of system_quad is

    component input_synch is
        port(
            mclk, reset, a, b : in std_logic;
            a_synch, b_synch  : out std_logic
        );
    end component;


    component quad is
        port(
            mclk             : in std_logic; 
            reset            : in std_logic; 
            SA, SB           : in std_logic;
            POS_INC, POS_DEC : out std_logic
        );
    end component;

    component velocity_reader is
        port(
            mclk      : in std_logic;
            reset     : in std_logic;
            pos_inc   : in std_logic;
            pos_dec   : in std_logic;
            velocity  : out signed(7 downto 0) -- rpm value updated every 1/100 s 
        );
    end component;

    component seg7ctrl is
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
    
    signal intermediate_a, intermediate_b, inc, dec: std_logic := '0';
    signal vel     : signed(7 downto 0) := (others => '0');
    signal abs_vel : unsigned(7 downto 0):= (others => '0');
    signal d0, d1  : std_logic_vector(3 downto 0):= (others => '0');

begin


    inputs: component input_synch
    port map(
        mclk => mclk,
        reset => reset,
        a => a,
        b => b,
        a_synch => intermediate_a, --output
        b_synch => intermediate_b --output
    );

    quadrature: component quad
    port map(
        mclk => mclk,
        reset => reset,
        SA => intermediate_a,
        SB => intermediate_b,
        POS_INC => inc, --output
        POS_DEC => dec --output
    );
    


    vel_read: component velocity_reader
    port map(
        mclk => mclk,
        reset => reset,
        pos_inc => inc,
        pos_dec => dec,
        velocity => vel -- output
    );

    abs_vel <= unsigned(abs(vel));
    d0 <= std_logic_vector(abs_vel(3 downto 0));
    d1 <= std_logic_vector(abs_vel(7 downto 4));

    seg7: component seg7ctrl
    port map(
        mclk => mclk,
        reset => reset,
        d0 => d0,
        d1 => d1,
        abcdefg => abcdefg, --output
        c => c--output
    );

end architecture rtl;

