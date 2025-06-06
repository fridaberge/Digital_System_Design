--decoder_ent.vhd only contains the entity declaration, no architecture.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity decoder is
  port
    (
        inp       : in  std_ulogic_vector(1 downto 0);    -- input signals
        outp      : out  std_ulogic_vector(3 downto 0)  -- Start value
    );
end decoder;