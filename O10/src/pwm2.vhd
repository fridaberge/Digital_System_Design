library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm2 is
    generic(WIDTH: natural := 20); 

    port(
        mclk, reset : in std_logic;
        duty_cycle  : in std_logic_vector(7 downto 0);
        dir, en     : out std_logic 
    );
end entity pwm2;

architecture rtl of pwm2 is

    component pdm is
    port(
            clk, reset, mea_req     : in std_logic;
            -- setpoint                : in std_logic_vector(WIDTH-1 downto 0);
            setpoint, min_off, min_on, max_on : in std_logic_vector(WIDTH-1 downto 0);
            mea_ack, pdm_pulse      : out std_logic 
        );
    end component;

    type statetype is (reverse_idle, reverse, forward_idle, forward);
    signal r_state, next_state      : statetype;
    signal mea_ack: std_logic; --not in use
    signal pulse: std_logic;
    signal pwm_setpoint: std_logic_vector(WIDTH-1 downto 0):= (others => '0');
    signal duty: std_logic_vector(7 downto 0):= (others => '0');
    --alias duty : std_logic_vector is pwm_setpoint(WIDTH-1 downto WIDTH-7);


    signal dc : u_unsigned(WIDTH-1 downto 0):= (others => '0');
    --signal dc_signed : signed(WIDTH-1 downto 0):= (others => '0');
    --signal dc : std_logic_vector(19 downto 0):= (others => '0');


    begin
        
        

        PDM2: component pdm  
        port map(
            clk => mclk,
            reset => reset,
            mea_req => '0',
            setpoint => pwm_setpoint, --std_logic_vector(dc)
            min_off => x"000FF",
            min_on => x"00FF0",
            max_on => x"FFF00",
            mea_ack => mea_ack,
            pdm_pulse => pulse
        );


        --dc(WIDTH-1 downto WIDTH-9) <= to_unsigned(abs(to_integer(signed(duty_cycle))), 8); --casting 8 bits to u_unsigned
        -- dc_signed(WIDTH-1 downto WIDTH-9) <= unsigned(abs(signed(duty_cycle)));
        -- dc(WIDTH-10 downto 0) <= (others => '0');

        process(mclk) is
            variable abs_duty : std_logic_vector(7 downto 0);

            --from yngve
            --variable duty_cycle_signed : signed(duty_cycle);
            --variable abs_duty: unsigned(abs(signed(duty_cycle)));
        begin
            if rising_edge(mclk) then
                if reset = '1' then
                    r_state <= reverse_idle;

                else
                    r_state <= next_state;
                    -- duty <= duty_cycle;
                    --duty <= std_logic_vector(unsigned(abs(signed(duty_cycle))));
                     -- pwm_setpoint <= (19 downto 13 => duty(6 downto 0), others => '0');


                    --from felix
                    abs_duty := std_logic_vector(unsigned(abs(signed(duty_cycle))));
                    duty <= (others =>'1') when abs_duty(7) else abs_duty;
                    pwm_setpoint(19 downto 13) <= duty(6 downto 0);
                    pwm_setpoint(12 downto 0) <= (others => '0');


                    -- --from yngve
                    -- dc(19 downto 12) <= to_unsigned(abs(to_integer(signed(duty_cycle))), 8); --casting 8 bits to u_unsigned
                    -- --dc(19 downto 12) <= unsigned(abs(signed(duty_cycle)));
                    -- dc(11 downto 0) <= (others => '0');


                    -- if signed(duty_cycle) < 0 then
                    --     dc(19 downto 12) <= std_logic_vector(unsigned(not duty_cycle)+1);
                    -- else
                    --     dc(19 downto 12) <= duty_cycle;
                    -- end if;
                    -- dc(11 downto 0) <= (others => '0');


                end if;
            end if;
        end process;
    

        STATE_TRANSITIONS: process(all) is
        begin
    
            next_state <= r_state;
            
            case r_state is
    
                when reverse_idle =>
                    next_state <=
                        reverse when (to_integer(signed(duty_cycle)) < 0)
                        else forward_idle;
    
                when reverse => 
                    next_state <= 
                        reverse_idle when (to_integer(signed(duty_cycle)) >= 0)
                        else reverse;
    
                when forward_idle =>
                    next_state <= 
                        reverse_idle when (to_integer(signed(duty_cycle)) <= 0)
                        else forward;
                
                when forward =>
                    next_state <=
                        forward_idle when (to_integer(signed(duty_cycle)) <= 0)
                        else forward;
            end case;
        end process;


        STATE_OUTPUT: process(all) is
        begin

            case r_state is
                when reverse_idle =>
                    dir <= '0';
                    en <= '0';
    
                when forward_idle => 
                    dir <= '1';
                    en <= '0';

                when forward =>
                    dir <= '1';
                    en <= pulse;
     
                when reverse =>
                    dir <= '0';
                    en <= pulse;
  
            end case;        
        end process;

        
end architecture rtl;