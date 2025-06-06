library ieee;
use ieee.std_logic_1164.all;


entity shift8 is 
    port ( 
        rst_n , mclk : in  std_logic;   -- Reset, Clock
        inp          : in  std_logic;   -- Data in
        serial    : out std_ulogic; --Data out serial
        parallel: out std_ulogic_vector(7 downto 0) -- Data out paralell
    );      
end entity shift8;


architecture structural of shift8 is
    component dff is
        port(
            rst_n , mclk : in  std_logic;   -- Reset, Clock
            din          : in  std_logic;   -- Data in
            dout         : out std_logic   -- Data out
        );
    end component;

    ---signal parallel: std_ulogic_vector(7 downto 0); -- Data out paralell
     
    begin

        flipflop1: component dff
            port map(
                rst_n => rst_n,
                mclk => mclk,
                din => inp,
                dout=> parallel(7)
            );

        flipflop2: component dff
            port map(
                rst_n => rst_n,
                mclk => mclk,
                din => parallel(7),
                dout=> parallel(6)
            );

        flipflop3: component dff
            port map(
                rst_n => rst_n,
                mclk => mclk,
                din => parallel(6),
                dout=> parallel(5)
            );

        flipflop4: component dff
            port map(
                rst_n => rst_n,
                mclk => mclk,
                din => parallel(5),
                dout=> parallel(4)
            );

        flipflop5: component dff
            port map(
                rst_n => rst_n,
                mclk => mclk,
                din => parallel(4),
                dout=> parallel(3)
            );

        flipflop6: component dff
            port map(
                rst_n => rst_n,
                mclk => mclk,
                din => parallel(3),
                dout=> parallel(2)
            );

        flipflop7: component dff
            port map(
                rst_n => rst_n,
                mclk => mclk,
                din => parallel(2),
                dout=> parallel(1)
            );

        flipflop8: component dff
            port map(
                rst_n => rst_n,
                mclk => mclk,
                din => parallel(1),
                dout=> parallel(0)
            );
        serial <= parallel(0);
    
    end architecture structural;