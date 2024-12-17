library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity INSTRUCTION_ROM is
    port(
        clk : in std_logic;
        enable : in std_logic;
        write_en : out std_logic;
        data_in_mode : out std_logic;
        mode: out std_logic_vector(7 downto 0);
        sel : out std_logic_vector(1 downto 0);
        addr_00 : out std_logic_vector(6 downto 0);
        addr_10 : out std_logic_vector(6 downto 0);
        addr_11 : out std_logic_vector(6 downto 0);
        addr1 : out std_logic_vector(5 downto 0); 
        addr2 : out std_logic_vector(5 downto 0)
    );
end INSTRUCTION_ROM;

architecture behavioral of INSTRUCTION_ROM is
    type rom_type is array (0 to 16) of std_logic_vector(44 downto 0);
    signal ROM : rom_type := (
        "010000000000000000100000100000011000000000000","010000000000000000100000100000011000000001000",
        "010000000000000000100000100000011000000010000","010000000000000000100000100000011000000011000",
        "010000000000000000100000100000011000000000001","010000000000000000100000100000011000000001001",
        "010000000000000000100000100000011000000010001","010000000000000000100000100000011000000011001",
        "010000000000000000100000100000011000000000010","010000000000000000100000100000011000000001010",
        "010000000000000000100000100000011000000010010","010000000000000000100000100000011000000011010",
        "010000000000000000100000100000011000000000011","010000000000000000100000100000011000000001011",
        "010000000000000000100000100000011000000010011","010000000000000000100000100000011000000011011",
        "000000000000000000000000000000000000000000000"
    );
    attribute rom_style : string;
    attribute rom_style of ROM : signal is "block";
    signal instr : std_logic_vector(44 downto 0);
begin
    process(clk)
        variable PC : integer := 0;
        constant LIMIT : integer := 16;
    begin
        if rising_edge(clk) then
            if enable = '1' and PC < LIMIT then
                instr <= ROM(PC);
                write_en <= instr(44); 
                data_in_mode <= instr(43);
                sel <= instr(42 downto 41);
                mode <= instr(40 downto 33);
                addr_00 <= instr(32 downto 26);
                addr_10 <= instr(25 downto 19);
                addr_11 <= instr(18 downto 12);
                addr1 <= instr(11 downto 6);
                addr2 <= instr(5 downto 0);

                PC := PC + 1;
            else
                PC := 0;
            end if;
        end if;
    end process;

end behavioral;