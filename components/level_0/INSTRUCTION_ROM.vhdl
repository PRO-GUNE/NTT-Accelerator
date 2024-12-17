library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity INSTRUCTION_ROM is
    port(
        clk : in std_logic;
        enable : in std_logic;
        write_en : out std_logic;
        data_in_mode : out std_logic;
        sel : out std_logic_vector(1 downto 0);
        addr_00 : out std_logic_vector(6 downto 0);
        addr_10 : out std_logic_vector(6 downto 0);
        addr_11 : out std_logic_vector(6 downto 0);
        addr_r : out std_logic_vector(5 downto 0); 
        addr_w : out std_logic_vector(5 downto 0)
    );
end INSTRUCTION_ROM;

architecture behavioral of INSTRUCTION_ROM is
    type rom_type is array (0 to 127) of std_logic_vector(36 downto 0);
    signal ROM : rom_type := (
    );
    attribute rom_style : string;
    attribute rom_style of ROM : signal is "block";
    signal instr : std_logic_vector(36 downto 0);
begin
    process(clk)
        variable PC : integer := 0;
    begin
        if rising_edge(clk) then
            if enable = '1' and PC < 128 then
                instr <= ROM(PC);
                write_en <= instr(36); 
                data_in_mode <= instr(35);
                sel <= instr(34 downto 33);
                addr_00 <= instr(32 downto 26);
                addr_10 <= instr(25 downto 19);
                addr_11 <= instr(18 downto 12);
                addr_r <= instr(11 downto 6);
                addr_w <= instr(5 downto 0);

                PC := PC + 1;
            else
                PC := 0;
            end if;
        end if;
    end process;

end behavioral;