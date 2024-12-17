library ieee;
use ieee.std_logic_1164.all;

entity REG_16 is
    port (
        clk : in std_logic;
        reset : in std_logic;
        enable : in std_logic;
        data_in : in std_logic_vector(15 downto 0);
        data_out : out std_logic_vector(15 downto 0)
    );
end entity REG_16;

architecture behavioral of REG_16 is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                data_out <= (others => '0');
            elsif enable = '1' then
                data_out <= data_in;
            end if;
        end if;
    end process;

end architecture behavioral;