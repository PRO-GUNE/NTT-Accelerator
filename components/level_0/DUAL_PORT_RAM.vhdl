library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.system_types.all;

entity DUAL_PORT_RAM is
    port (
        clk      : in  std_logic;
        en1      : in  std_logic;
        en2      : in  std_logic;
        addr1    : in  std_logic_vector(ADDR_SIZE downto 0);
        addr2    : in  std_logic_vector(ADDR_SIZE downto 0);
        write_en : in  std_logic;
        data_in  : in  std_logic_vector(DATA_SIZE-1 downto 0);
        data_out : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end DUAL_PORT_RAM;

architecture behavioral of DUAL_PORT_RAM is
    type ram_type is array (2 ** ADDR_SIZE - 1 downto 0) of std_logic_vector(DATA_SIZE-1 downto 0);
    signal RAM : ram_type := (
        X"00c0008000400000",X"00c2008200420002",X"00c4008400440004",X"00c6008600460006",
        X"00c8008800480008",X"00ca008a004a000a",X"00cc008c004c000c",X"00ce008e004e000e",
        X"00d0009000500010",X"00d2009200520012",X"00d4009400540014",X"00d6009600560016",
        X"00d8009800580018",X"00da009a005a001a",X"00dc009c005c001c",X"00de009e005e001e",
        X"00e000a000600020",X"00e200a200620022",X"00e400a400640024",X"00e600a600660026",
        X"00e800a800680028",X"00ea00aa006a002a",X"00ec00ac006c002c",X"00ee00ae006e002e",
        X"00f000b000700030",X"00f200b200720032",X"00f400b400740034",X"00f600b600760036",
        X"00f800b800780038",X"00fa00ba007a003a",X"00fc00bc007c003c",X"00fe00be007e003e"
    );
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if en1 = '1' then
                if write_en = '1' then
                    RAM(conv_integer(addr1)) <= data_in;
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
