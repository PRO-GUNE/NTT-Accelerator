library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity DUAL_PORT_RAM is
    generic (
        ADDR_SIZE : integer := 32;
        DATA_SIZE : integer := 48
    );
    port (
        clk       : in  std_logic;
        en_1      : in  std_logic;
        en_2      : in  std_logic;
        addr1     : in  std_logic_vector(ADDR_SIZE-1 downto 0);
        addr2     : in  std_logic_vector(ADDR_SIZE-1 downto 0);
        write_en  : in  std_logic;
        data_in   : in  std_logic_vector(DATA_SIZE-1 downto 0);
        data_out : out std_logic_vector(DATA_SIZE-1 downto 0);
    );
end DUAL_PORT_RAM;

architecture behavioral of DUAL_PORT_RAM is
    type ram_type is array (natural range <>) of std_logic_vector(DATA_SIZE-1 downto 0);
    shared variable RAM : ram_type;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if write_en = '1' and en_1 = '1' then
                RAM(conv_integer(addr1)) := data_in;
            end if;
        end if;
    end process;

    process (clk)
    begin
        if rising_edge(clk) then
            if en_2 = '1' then
                data_out <= RAM(conv_integer(addr2));
            end if;
        end if;
    end process;
end behavioral;