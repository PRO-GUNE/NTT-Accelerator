library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MOD_ADD is
    port (
        a : in std_logic_vector(11 downto 0);
        b : in std_logic_vector(11 downto 0);
        sum : out std_logic_vector(11 downto 0)
    );
end entity MOD_ADD;

architecture behavioral of MOD_ADD is
begin
    process(a, b)
        constant MODULO : natural := 3329;
        variable temp_sum : integer;
    begin
        temp_sum := to_integer(unsigned(a)) + to_integer(unsigned(b));
        if temp_sum >= MODULO then
            temp_sum := temp_sum - MODULO;
        end if;
        sum <= std_logic_vector(to_unsigned(temp_sum, 12));
    end process;
end architecture behavioral;