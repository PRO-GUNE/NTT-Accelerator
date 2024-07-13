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
        variable temp_sum : unsigned(11 downto 0);
    begin
        temp_sum := unsigned(a) + unsigned(b);
        if temp_sum >= MODULO then
            temp_sum := temp_sum - MODULO;
        end if;
        sum <= std_logic_vector(temp_sum);
    end process;
end architecture behavioral;