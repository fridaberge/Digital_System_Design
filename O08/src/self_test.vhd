library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;


entity self_test is
    generic 
    (
        filename: string := "ROM_data.txt";
        M:  natural:=300000000; --100M = 1 sec, so 300M= 3 sec
        data_size: natural := 8; --8 bits at each address
        num_values: natural := 20 --20 values
    ); 
    port
    (
        --address : in std_ulogic_vector(num_values-1 downto 0);
        data    : out std_ulogic_vector(data_size-1 downto 0);
        clk     : in std_logic; --100MHz, positive flank
        reset   : in std_logic; --Asynchronous reset, active high
        change  : out integer
    );
end entity self_test;


architecture synth of self_test is 
    signal sec_counter : unsigned(28 downto 0):= (others => '0');  --29 digits to display 300M

    type memory_array is array(num_values-1 downto 0) of
        std_ulogic_vector(data_size-1 downto 0);

    impure function initialize_ROM(file_name: string)
        return memory_array is
        file init_file: text open read_mode is file_name;
        variable current_line: line;
        variable result: memory_array;
    begin
        for i in result'range loop
            readline(init_file, current_line);
            read(current_line, result(i));
        end loop;
        return result;
    end; -- function end


    constant ROM_DATA: memory_array := initialize_ROM(filename);

begin
    process(all) is
        variable address : integer := 0;

    begin
        if rising_edge(clk) then
            
            if reset='1' then
                sec_counter <= (others => '0');
                data <= (others => '0');
                change <= 0;

            elsif sec_counter = M then
                --data <= ROM_DATA(to_integer(signed(address)));
                --adresse <= (to_integer(signed(address)));
                --data <= ROM_DATA(adresse);

                data <= ROM_DATA(address);
                if address < num_values-1 then
                    address := address +1;
                end if;
                if change = 0 then
                    change <= 1;
                else
                    change <= 0;
                end if;
                sec_counter <= (others => '0');
            else
                sec_counter <= sec_counter + 1;
            end if;
        end if;

    end process; --process end
end synth;
  




