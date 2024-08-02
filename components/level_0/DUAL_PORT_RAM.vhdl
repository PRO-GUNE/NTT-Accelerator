library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity DUAL_PORT_RAM is
    generic (
        ADDR_SIZE : integer := 6;
        DATA_SIZE : integer := 48
    );
    port (
        clk       : in  std_logic;
        en1       : in std_logic;
        en2       : in std_logic;
        addr1     : in  std_logic_vector(ADDR_SIZE-1 downto 0);
        addr2     : in  std_logic_vector(ADDR_SIZE-1 downto 0);
        write_en  : in  std_logic;
        data_in   : in  std_logic_vector(DATA_SIZE-1 downto 0);
        data_out : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end DUAL_PORT_RAM;

architecture behavioral of DUAL_PORT_RAM is
    type ram_type is array (2 ** ADDR_SIZE downto 0) of std_logic_vector(DATA_SIZE-1 downto 0);
    shared variable RAM : ram_type;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if en1 = '1' then
                if write_en = '1' then
                    RAM(conv_integer(addr1)) := data_in;
                end if;
            end if;
        end if;    
    end process;

    process (clk)
    begin
        if rising_edge(clk) then
            if en2 = '1' then
                data_out <= RAM(conv_integer(addr2));
            end if;
        end if;
    end process;

end behavioral;
