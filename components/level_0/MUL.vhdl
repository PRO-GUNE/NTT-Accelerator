library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUL is
    port (
        a : in std_logic_vector(15 downto 0);
        b : in std_logic_vector(15 downto 0);
        result : out std_logic_vector(23 downto 0)
    );
end entity MUL;

architecture rtl of MUL is
begin
    process(a, b)
        variable mul_ab : integer;
    begin
        mul_ab := to_integer(unsigned(a)) * to_integer(unsigned(b));
        result <= std_logic_vector(to_unsigned(mul_ab, 24));
    end process;
end architecture rtl;