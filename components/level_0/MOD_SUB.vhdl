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
        variable temp_diff : integer;
    begin

        temp_diff := to_integer(unsigned(a)) - to_integer(unsigned(b));
        if temp_diff < 0 then
            temp_diff := temp_diff + MODULO;
        end if;
        diff <= std_logic_vector(to_unsigned(temp_diff, 12));
    end process;
end architecture behavioral;