
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package seg7_pkg is 
  function bin2ssd(di: std_logic_vector) return std_logic_vector;
  function bin2ssd_alt(di: std_logic_vector) return std_logic_vector;
end seg7_pkg;

Package body seg7_pkg is 

  function bin2ssd(di: std_logic_vector) 
    return std_logic_vector is
    variable outp: std_logic_vector(6 downto 0) := "0000000";
  begin
    with di select
      outp:="1111110" when "0000",
            "0110000" when "0001",
            "1101101" when "0010",
            "1111001" when "0011",
            "0110011" when "0100",
            "1011011" when "0101",
            "1011111" when "0110",
            "1110000" when "0111",
            "1111111" when "1000",
            "1111011" when "1001",
            "1110111" when "1010",
            "0011111" when "1011",
            "1001110" when "1100",
            "0111101" when "1101",
            "1001111" when "1110",
            "1000111" when "1111",
            "0000000" when others;
  return outp;
  end;



  function bin2ssd_alt(di: std_logic_vector) 
    return std_logic_vector is
    variable outp: std_logic_vector(6 downto 0) := "0000000";
  begin
    with di select
      outp:="0000000" when "0000",
            "0011110" when "0001",
            "0111100" when "0010",
            "1001111" when "0011",
            "0001110" when "0100",
            "0111101" when "0101",
            "0011101" when "0110",
            "0010101" when "0111",
            "0111011" when "1000",
            "0111110" when "1001",
            "1110111" when "1010",
            "0000101" when "1011",
            "1111011" when "1100",
            "0011100" when "1101",
            "0001101" when "1110",
            "1111111" when "1111",
            "0000000" when others;
  return outp;
  end;
end seg7_pkg;

