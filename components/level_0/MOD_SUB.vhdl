library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MOD_SUB is
    port (
        a : in std_logic_vector(11 downto 0);
        b : in std_logic_vector(11 downto 0);
        diff : out std_logic_vector(11 downto 0)
    );
end entity MOD_SUB;

architecture behavioral of MOD_SUB is
begin
    process(a, b)
        constant MODULO : natural := 3329;
        variable temp_diff : unsigned(11 downto 0);
    begin
        temp_diff := unsigned(a) - unsigned(b);
        if temp_diff < 0 then
            temp_diff := MODULO - temp_diff;
        end if;
        diff <= std_logic_vector(temp_diff);
    end process;
end architecture behavioral;