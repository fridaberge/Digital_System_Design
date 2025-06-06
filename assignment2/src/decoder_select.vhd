--decoder _select only contains the architecture declaration for the architecture using select (task b) 
--Beware that you will need to make clean in between simulations of the different architectures:

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- The architecture below describes a 2-to-4 bit decoder 
architecture RTL of decoder is begin
  process(inp) begin
    with inp select
        outp <= "1110" when "00",
                "1101" when "01",
                "1011" when "10",
                "0111" when "11",
                "0000" when others;
  end process;
end RTL;