library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm is
    generic(WIDTH: natural := 20); 
    port(
        mclk, reset : in std_logic;
        duty_cycle  : in std_logic_vector(7 downto 0);
        dir, en     : out std_logic 
    );
end entity pwm;

architecture rtl of pwm is
    -- signal time_off: unsigned(WIDTH-1 downto 0)  := x"000FF";
    -- signal time_on: unsigned(WIDTH-1 downto 0)   := x"00FF0";
    -- signal period: unsigned(WIDTH-1 downto 0)    := x"010EF"; --off_time+on_time

    type statetype is (reverse_idle, reverse, forward_idle, forward);
    signal r_state, next_state      : statetype;
    signal timer                    : unsigned(13 downto 0);
    alias pwm_sig                   : std_logic is timer(timer'left); --bit 7 of
    signal r_en, next_en, r_dir     : std_logic := '0';

begin
    en <= r_en;
    dir <= r_dir;

    process(mclk, reset)
    begin
        if rising_edge(mclk) then
        ------------------RESET-----------------------------------
            if reset = '1' then
                r_state <= reverse_idle;
                -- r_dir <= '0';
                -- r_en <= '0';
                timer <= (others => '0');
        -------------------NOT RESET----------------------------------
            else
                r_state <= next_state;
                timer <= timer + 1;
                if r_state = forward_idle and to_integer(signed(duty_cycle)) < 0 and r_en = '0' then
                    r_dir <= '0';
                elsif r_state = reverse_idle and to_integer(signed(duty_cycle)) > 0 and r_en = '0' then
                    r_dir <= '1';
                end if;
            end if;
        end if;

    end process;

    -----------------------_STATES----------------------------------------------------------------------------------
    --Here we decide what the next state should be after the current one
    STATE_TRANSITIONS: process(mclk) is
    begin

        next_state <= r_state;
        
        case r_state is

            when reverse_idle => en <= '0';
                next_state <=
                    reverse when (to_integer(signed(duty_cycle)) < 0)
                    else forward_idle;

            when reverse => 
                if timer > unsigned(abs(signed(duty_cycle))) then
                    en <= pwm_sig;
                else 
                    en <= '0';
                end if;
                next_state <= 
                    reverse_idle when (to_integer(signed(duty_cycle)) >= 0);

            when forward_idle => en <= '0';
                next_state <= 
                    reverse_idle when (to_integer(signed(duty_cycle)) <= 0)
                    else forward;
            
            when forward =>
                if timer > unsigned(abs(signed(duty_cycle))) then
                    en <= pwm_sig;
                else
                    en <= '0';
                end if;
                next_state <=
                    forward_idle when (to_integer(signed(duty_cycle)) <= 0);
        end case;
    end process;

end architecture rtl;