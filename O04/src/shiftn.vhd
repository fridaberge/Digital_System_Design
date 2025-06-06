library ieee;
use ieee.std_logic_1164.all;


entity shiftn is
    generic(N: positive := 64);
    port ( 
        rst_n , mclk : in  std_logic;   -- Reset, Clock
        inp          : in  std_logic;   -- Data in
        serial    : out std_ulogic --Data out serial
        --parallel: out std_ulogic_vector(7 downto 0) -- Data out paralell
    );      
end entity shiftn;


architecture structural of shiftn is
    component dff is
        port(
            rst_n , mclk : in  std_logic;   -- Reset, Clock
            din          : in  std_logic;   -- Data in
            dout         : out std_logic   -- Data out
        );
    end component;

    signal parallel: std_ulogic_vector(N-1 downto 0); -- Data out paralell

    begin

        flipflop1: component dff
            port map(
                rst_n => rst_n,
                mclk => mclk,
                din => inp,
                dout=> parallel(0)
            );
        
        --generate didnt work woth counting downwards, so i switched to counting upwards instead
        shiftreg: for i in 1 to N-1 generate
            flipflop: component dff
                port map(
                    rst_n => rst_n,
                    mclk => mclk,
                    din => parallel(i-1),
                    dout=> parallel(i)
                );
        end generate;
        serial <= parallel(N-1);
    
    end architecture structural;