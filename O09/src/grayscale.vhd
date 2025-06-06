library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity grayscale is
  generic ( N : natural := 8);
  port(
    reset, clk           : in  std_logic;
    R, G, B, WR, WG, WB  : in  std_logic_vector(N-1 downto 0);
    RGB_valid            : in  std_logic;
    Y                    : out std_logic_vector(N-1 downto 0);     
    overflow, Y_valid    : out std_logic
  );
end entity grayscale;


architecture RTL of grayscale is
  signal next_Y, r_Y               : unsigned(N-1 downto 0);
  signal next_valid, r_valid, 
         next_overflow, r_overflow : std_logic;
  signal valid                   : std_logic;
  signal r_R, r_G, r_B             : unsigned(2*N-1 downto 0);
  signal f_R, f_G, f_B             : unsigned(2*N-1 downto 0);
begin
  -- output from registers
  Y        <= std_logic_vector(r_Y);
  overflow <= r_overflow;
  Y_valid  <= r_valid;
  valid <= RGB_valid;
  
  REG_ASSIGNMENT: process(clk) is  
  begin 
    if rising_edge(clk) then 
      if reset then 
        r_Y        <= (others => '0');
        r_valid    <= '0';
        r_overflow <= '0';
      
      else
        --at register 2
        r_Y        <= next_Y;
        r_valid    <= next_valid;
        r_overflow <= next_overflow;

        --at register 1
        next_valid <= valid;
        r_R <= f_R;
        r_G <= f_G;
        r_B <= f_B;
      end if;
    end if;
  end process; 
  

  STEP1: process (all) is
  begin
    f_R <= unsigned(WR) * unsigned(R);
    f_G <= unsigned(WG) * unsigned(G);
    f_B <= unsigned(WB) * unsigned(B);
    
  end process;

  
  STEP2: process (all) is
    variable i_sum  : unsigned(2*N+1 downto 0);
    variable i_overflow   : std_logic; 
  begin
    i_sum := unsigned("00" & r_R) + unsigned("00" & r_G) + unsigned("00" & r_B);
    i_overflow := or(i_sum(i_sum'left downto i_sum'left-1)); 
    next_Y <= (others => '1') when i_overflow else i_sum(2*N-1 downto N);
    next_overflow <= i_overflow;
    --next_valid <= i_valid;
  end process;

  
end architecture RTL;