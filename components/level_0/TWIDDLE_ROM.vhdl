-- ROM Inference on array
-- File: TWIDDLE_ROM.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TWIDDLE_ROM is
    port(
        clk : in std_logic;
        en : in std_logic;
        addr : in std_logic_vector(6 downto 0);
        data : out std_logic_vector(11 downto 0)
    );
end TWIDDLE_ROM;

architecture behavioral of TWIDDLE_ROM is
    type rom_type is array (127 downto 0) of std_logic_vector(11 downto 0);
    signal ROM : rom_type := (
        X"8b2", X"331", X"c0b", X"860", X"1a6", X"842", X"6cb", X"c95", 
        X"81e", X"52a", X"9f8", X"71b", X"bde", X"997", X"1a2", X"3be", 
        X"22b", X"25b", X"487", X"803", X"0b1", X"4c2", X"999", X"3e4", 
        X"60e", X"748", X"aa7", X"99b", X"626", X"85e", X"c65", X"5f2", 
        X"1ae", X"449", X"30a", X"707", X"24b", X"c79", X"284", X"bcd", 
        X"367", X"7fc", X"5cb", X"9ab", X"b35", X"0dc", X"149", X"74d", 
        X"34b", X"262", X"c6e", X"31a", X"c16", X"7ca", X"15d", X"3df", 
        X"069", X"180", X"45f", X"1de", X"675", X"686", X"cb6", X"65c", 
        X"44f", X"9d0", X"0f6", X"4a1", X"b5b", X"4bf", X"636", X"06c", 
        X"4e3", X"7d7", X"309", X"5e6", X"123", X"36a", X"b5f", X"943", 
        X"ad6", X"aa6", X"87a", X"4fe", X"c50", X"83f", X"368", X"91d", 
        X"6f3", X"5b9", X"25a", X"366", X"6db", X"4a3", X"09c", X"70f", 
        X"b53", X"8b8", X"9f7", X"5fa", X"ab6", X"088", X"a7d", X"134", 
        X"99a", X"505", X"736", X"356", X"1cc", X"c25", X"bb8", X"5b4", 
        X"9b6", X"a9f", X"093", X"9e7", X"0eb", X"537", X"ba4", X"922", 
        X"c98", X"b81", X"8a2", X"b23", X"68c", X"67b", X"04b", X"6a5",  
    );
    attribute rom_style : string;
    attribute rom_style of ROM : signal is "block";

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if (en = '1') then
                data <= ROM(to_integer(unsigned(addr)));
            end if;
        end if;
    end process;

end behavioral;