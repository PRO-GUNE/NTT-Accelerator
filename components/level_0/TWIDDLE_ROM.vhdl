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
        data_00 : out std_logic_vector(15 downto 0);
        data_10 : out std_logic_vector(15 downto 0);
        data_11 : out std_logic_vector(15 downto 0)
    );
end TWIDDLE_ROM;

architecture behavioral of TWIDDLE_ROM is
    type rom_type is array (0 to 127) of std_logic_vector(15 downto 0);
    signal ROM : rom_type := (
        X"08ed", X"0a0b", X"0b9a", X"0714", X"05d5", X"058e", X"011f", X"00ca", 
        X"0c56", X"026e", X"0629", X"00b6", X"03c2", X"084f", X"073f", X"05bc", 
        X"023d", X"07d4", X"0108", X"017f", X"09c4", X"05b2", X"06bf", X"0c7f", 
        X"0a58", X"03f9", X"02dc", X"0260", X"06fb", X"019b", X"0c34", X"06de", 
        X"04c7", X"028c", X"0ad9", X"03f7", X"07f4", X"05d3", X"0be7", X"06f9", 
        X"0204", X"0cf9", X"0bc1", X"0a67", X"06af", X"0877", X"007e", X"05bd", 
        X"09ac", X"0ca7", X"0bf2", X"033e", X"006b", X"0774", X"0c0a", X"094a", 
        X"0b73", X"03c1", X"071d", X"0a2c", X"01c0", X"08d8", X"02a5", X"0806", 
        X"08b2", X"01ae", X"022b", X"034b", X"081e", X"0367", X"060e", X"0069", 
        X"01a6", X"024b", X"00b1", X"0c16", X"0bde", X"0b35", X"0626", X"0675", 
        X"0c0b", X"030a", X"0487", X"0c6e", X"09f8", X"05cb", X"0aa7", X"045f", 
        X"06cb", X"0284", X"0999", X"015d", X"01a2", X"0149", X"0c65", X"0cb6", 
        X"0331", X"0449", X"025b", X"0262", X"052a", X"07fc", X"0748", X"0180", 
        X"0842", X"0c79", X"04c2", X"07ca", X"0997", X"00dc", X"085e", X"0686", 
        X"0860", X"0707", X"0803", X"031a", X"071b", X"09ab", X"099b", X"01de", 
        X"0c95", X"0bcd", X"03e4", X"03df", X"03be", X"074d", X"05f2", X"0cb3"  
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