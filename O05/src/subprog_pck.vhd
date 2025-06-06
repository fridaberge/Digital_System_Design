-- *******************************************************
-- ** Pargen, parity bit is odd (1) if the parity is odd *
-- ** If the parity is even parity bit is even (0)       *
-- *******************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package subprog_pck is 
    function method_1(indata: std_logic_vector) return std_logic;
    function method_2(indata: std_logic_vector) return std_logic;
end subprog_pck;

Package body subprog_pck is 

  --Method 1: parity toggle, using for, loop and variables.
  function method_1(indata: std_logic_vector) 
    return std_logic is
    variable toggle: std_ulogic := '0';
  begin
    for i in indata'range loop
      if indata(i) = '1' then
        toggle := not toggle;
      end if;        
    end loop;
    return toggle;
  end;

  
  -- Method: 2 parity using xor function (VHDL 2008)
  function method_2(indata: std_logic_vector)
  return std_logic is
  variable xoring: std_ulogic :='0';
  begin
    return xor(indata);
  end;

end subprog_pck;
