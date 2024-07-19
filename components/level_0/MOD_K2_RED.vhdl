library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MOD_K2_RED is
    port (
        c_in : in std_logic_vector(23 downto 0);
        c_out : out std_logic_vector(11 downto 0)
    );
end entity MOD_K2_RED;

architecture behavioral of MOD_K2_RED is
begin
    process(c_in)
        variable c_l, c_l1 : unsigned(7 downto 0);
        variable c_temp1 : unsigned(23 downto 0);
        variable c_h : unsigned(23 downto 8);
        variable c_h1 : unsigned(15 downto 8);
        variable c1, c_temp2 : unsigned(15 downto 0);
        variable c2 : unsigned(11 downto 0);
    begin        
        c_l := unsigned(c_in(7 downto 0));
        c_h := unsigned(c_in(23 downto 8));
        c_temp1 := (c_h - shift_left(c_l, 3)) + (shift_left(c_l, 2) - c_l);
        c1 := unsigned(c_temp1(15 downto 0));
        
        c_l1 := unsigned(c1(7 downto 0));
        c_h1 := unsigned(c1(15 downto 8));
        c_temp2 := (c_h1 - shift_left(c_l1, 3)) + (shift_left(c_l1, 2) - c_l1);
        c2 := unsigned(c_temp2(11 downto 0));

        c_out <= std_logic_vector(c2);
    end process;
end architecture behavioral;
