library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUL is
    port (
        a : in  unsigned(11 downto 0);
        b : in  unsigned(11 downto 0);
        result : out unsigned(23 downto 0)
    );
end entity MUL;

architecture rtl of MUL is
begin
    result <= a * b;
end architecture rtl;