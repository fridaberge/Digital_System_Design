library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pdm_1 is
  generic( WIDTH: natural := 16 ); 
  port(
    clk, reset, mea_req               : in std_logic;
    setpoint, min_off, min_on, max_on : in std_logic_vector(WIDTH-1 downto 0);
    mea_ack, pdm_pulse                : out std_logic 
  );
end entity pdm_1;

architecture rtl of pdm_1 is
  signal counter : unsigned(WIDTH-1 downto 0) := (others => '0');
  signal timer : integer := 0;
  signal r_acc, next_acc  : unsigned(WIDTH downto 0); -- acc=accumulator, +1bit  
  alias PDM_out : std_logic is r_acc(r_acc'left);     -- leftmost bit = “carry”

begin

  --r_acc <= next_acc when rising_edge(clk);
  --next_acc <= ("0" & unsigned(setpoint)) + ("0" & r_acc(WIDTH-1 downto 0));

  process(clk, reset)
  variable max : unsigned(WIDTH-1 downto 0) :=(others=>'1');

  begin

    if rising_edge(clk) then
      ------------------RESET-----------------------------------
      if reset = '1' then
        counter <= (others => '0');
        mea_ack <= '0';
        pdm_pulse <= '0';
        timer <= to_integer(unsigned(min_off));
        r_acc <= (others => '0');
        next_acc <= (others => '0');
      
      -------------------NOT RESET----------------------------------
      else
        r_acc <= next_acc;
        next_acc <= ("0" & unsigned(setpoint)) + ("0" & r_acc(WIDTH-1 downto 0));
      

        if timer > integer(0) then
          --default
          timer <= timer-integer(1);
        end if;
      
        ------------------PULSE OFF-----------------------------
        if PDM_pulse = '0' and mea_req = '0' then
          mea_ack <= '0';
          if PDM_out = '1' then
            if counter < max then
              counter <= counter + 1;
            end if;
            if timer = 0 then
              --going to pulse on next clock cycle
              if counter >= to_integer(unsigned(min_on)) then
                timer <= to_integer(unsigned(max_on));
                PDM_pulse <= '1';
              end if;
            end if;
          end if;
        end if;

        ------------------MEASURE--------------------------------
        if mea_req = '1' and PDM_pulse = '0' then
          mea_ack <= '1';
          PDM_pulse <= '0'; --unneccesary

        -----------------PULSE ON-------------------------------------
        elsif PDM_pulse = '1' then
          if PDM_out = '0' then
            if counter > integer(0) then 
              counter <= counter - 1;
            end if;

            --going to pulse off next clock cycle
            if timer = 0 or counter = 0 then
              timer <= to_integer(unsigned(min_off));
              PDM_pulse <= '0';
            end if;
          end if;
        end if;

      end if; -- reset
    end if; --rising edge(clk)         
  end process;
end architecture rtl;