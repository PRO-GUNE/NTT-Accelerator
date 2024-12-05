-- ROM Inference on array
-- File: TWIDDLE_ROM.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TWIDDLE_ROM is
    port(
        clk : in std_logic;
        en : in std_logic;
        addr_00 : in std_logic_vector(6 downto 0);
        addr_10 : in std_logic_vector(6 downto 0);
        addr_11 : in std_logic_vector(6 downto 0);
        data_00 : out std_logic_vector(11 downto 0);
        data_10 : out std_logic_vector(11 downto 0);
        data_11 : out std_logic_vector(11 downto 0)
    );
end TWIDDLE_ROM;

architecture behavioral of TWIDDLE_ROM is
    type rom_type is array (127 downto 0) of std_logic_vector(11 downto 0);
    signal ROM : rom_type := (
        X"8ed", X"a0b", X"b9a", X"714", X"5d5", X"58e", X"11f", X"0ca", 
        X"c56", X"26e", X"629", X"0b6", X"3c2", X"84f", X"73f", X"5bc", 
        X"23d", X"7d4", X"108", X"17f", X"9c4", X"5b2", X"6bf", X"c7f", 
        X"a58", X"3f9", X"2dc", X"260", X"6fb", X"19b", X"c34", X"6de", 
        X"4c7", X"28c", X"ad9", X"3f7", X"7f4", X"5d3", X"be7", X"6f9", 
        X"204", X"cf9", X"bc1", X"a67", X"6af", X"877", X"07e", X"5bd", 
        X"9ac", X"ca7", X"bf2", X"33e", X"06b", X"774", X"c0a", X"94a", 
        X"b73", X"3c1", X"71d", X"a2c", X"1c0", X"8d8", X"2a5", X"806", 
        X"8b2", X"1ae", X"22b", X"34b", X"81e", X"367", X"60e", X"069", 
        X"1a6", X"24b", X"0b1", X"c16", X"bde", X"b35", X"626", X"675", 
        X"c0b", X"30a", X"487", X"c6e", X"9f8", X"5cb", X"aa7", X"45f", 
        X"6cb", X"284", X"999", X"15d", X"1a2", X"149", X"c65", X"cb6", 
        X"331", X"449", X"25b", X"262", X"52a", X"7fc", X"748", X"180", 
        X"842", X"c79", X"4c2", X"7ca", X"997", X"0dc", X"85e", X"686", 
        X"860", X"707", X"803", X"31a", X"71b", X"9ab", X"99b", X"1de", 
        X"c95", X"bcd", X"3e4", X"3df", X"3be", X"74d", X"5f2", X"65c", 
        X"8b2", X"44f", X"1ae", X"b53", X"22b", X"ad6", X"34b", X"9b6", 
        X"81e", X"4e3", X"367", X"99a", X"60e", X"6f3", X"069", X"c98", 
        X"1a6", X"b5b", X"24b", X"ab6", X"0b1", X"c50", X"c16", X"0eb", 
        X"bde", X"123", X"b35", X"1cc", X"626", X"6db", X"675", X"68c", 
        X"c0b", X"0f6", X"30a", X"9f7", X"487", X"87a", X"c6e", X"093", 
        X"9f8", X"309", X"5cb", X"736", X"aa7", X"25a", X"45f", X"8a2", 
        X"6cb", X"636", X"284", X"a7d", X"999", X"368", X"15d", X"ba4", 
        X"1a2", X"b5f", X"149", X"bb8", X"c65", X"09c", X"cb6", X"04b", 
        X"331", X"9d0", X"449", X"8b8", X"25b", X"aa6", X"262", X"a9f", 
        X"52a", X"7d7", X"7fc", X"505", X"748", X"5b9", X"180", X"b81", 
        X"842", X"4bf", X"c79", X"088", X"4c2", X"83f", X"7ca", X"537", 
        X"997", X"36a", X"0dc", X"c25", X"85e", X"4a3", X"686", X"67b", 
        X"860", X"4a1", X"707", X"5fa", X"803", X"4fe", X"31a", X"9e7", 
        X"71b", X"5e6", X"9ab", X"356", X"99b", X"366", X"1de", X"b23", 
        X"c95", X"06c", X"bcd", X"134", X"3e4", X"91d", X"3df", X"922", 
        X"3be", X"943", X"74d", X"5b4", X"5f2", X"70f", X"65c", X"163"  
    );
    attribute rom_style : string;
    attribute rom_style of ROM : signal is "block";

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if (en = '1') then
                data_00 <= ROM(to_integer(unsigned(addr_00)));
                data_10 <= ROM(to_integer(unsigned(addr_10)));
                data_11 <= ROM(to_integer(unsigned(addr_11)));
            end if;
        end if;
    end process;

end behavioral;