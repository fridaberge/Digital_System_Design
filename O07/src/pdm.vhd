library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pdm is
    generic( WIDTH: natural := 16 ); 
    port(
        clk, reset, mea_req               : in std_logic;
        setpoint, min_off, min_on, max_on : in std_logic_vector(WIDTH-1 downto 0);
        mea_ack, pdm_pulse                : out std_logic 
    );
end entity pdm;

architecture rtl of pdm is
    constant max : unsigned(WIDTH-1 downto 0) :=(others=>'1');

    type statetype is (pulse_low, pulse_high, measure);
    signal r_state, next_state: statetype;
    signal counter, next_counter : unsigned(WIDTH-1 downto 0) := (others => '0');
    signal timer , next_timer: integer := 0;
    signal r_acc, next_acc  : unsigned(WIDTH downto 0):= (others => '0'); -- acc=accumulator, +1bit  
    alias PDM_out : std_logic is r_acc(r_acc'left);     -- leftmost bit = “carry”


begin
    process(clk, reset)
    begin

        if rising_edge(clk) then
        ------------------RESET-----------------------------------
            if reset = '1' then
                counter <= (others => '0');
                -- mea_ack <= '1';
                -- pdm_pulse <= '0';
                timer <= to_integer(unsigned(max_on));
                r_state <= pulse_low;
                r_acc <= (others => '0');
        
        -------------------NOT RESET----------------------------------
            else
                r_state <= next_state; 
                counter <= next_counter;
                timer <= next_timer;
                r_acc <= next_acc;
                next_acc <= ("0" & unsigned(setpoint)) + ("0" & r_acc(WIDTH-1 downto 0));

            end if;
        end if;

    end process;



    -----------------------_STATES----------------------------------------------------------------------------------
    --Here we decide what the next state should be after the current one
    STATE_TRANSITIONS: process(clk) is
    begin
        next_state <= r_state;
        case r_state is
            when pulse_low => pdm_pulse <= '0';
                mea_ack <= '0'; 
                next_state <=
                    measure when (mea_req = '1') else
                    pulse_high when (timer = 0) and (counter >= to_integer(unsigned(min_on)));
                
            when pulse_high => PDM_pulse <= '1';
                next_state <= pulse_low when (timer = 0) or (counter = 0);

            when measure => mea_ack <= '1'; 
                    --pdm_pulse <= '0';
                    next_state <= pulse_low when (mea_req = '0');
        end case;
    end process;

    
    --the output from each state when we go from one state to another
    STATE_OUTPUT: process(clk) is
    begin
        --default
        next_counter <= counter;
        next_timer <= timer;


        if timer > integer(0) then
          next_timer <= timer-integer(1);
        end if;

        case r_state is
            when pulse_low => 
                if next_state = pulse_high then
                    next_timer <= to_integer(unsigned(max_on));
    
                end if;

                if PDM_out = '1' then
                    if counter < max then
                        next_counter <= counter + 1;
                    end if;
                end if;

            when pulse_high => 
                if next_state = pulse_low then
                    next_timer <= to_integer(unsigned(min_off));
                end if;

                if PDM_out = '0' or counter>0 then
                    next_counter <= counter-1;
                end if;
            when measure => null;
        end case;        
  end process;
end architecture rtl;