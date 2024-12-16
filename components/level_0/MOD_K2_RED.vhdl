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
    signal c1_test : signed(15 downto 0);
    signal c2_test : unsigned(11 downto 0);
begin
    process(c_in)
        variable c_l: unsigned(15 downto 0);
        variable c_l1, c_h1: signed(11 downto 0); 
        variable c_h : unsigned(23 downto 8);
        variable c1 : signed(15 downto 0);
        variable c2 : unsigned(11 downto 0);
        variable c1_val, c2_val : integer := 0;
    begin        
        c_l := resize(unsigned(c_in(7 downto 0)), 16);
        c_h := unsigned(c_in(23 downto 8));
        c1_val := to_integer((shift_left(c_l, 3) - c_h) + (shift_left(c_l, 2) + c_l));
        c1 := to_signed(c1_val, 16);
        c1_test <= c1;
        
        c_h1 := resize(signed(c1(15 downto 8)), 12);
        c_l1 := signed(resize(unsigned(c1(7 downto 0)), 12));
        c2_val := to_integer((shift_left(c_l1, 3) - c_h1) + (shift_left(c_l1, 2) + c_l1));
        c2 := to_unsigned(c2_val, 12);
        c2_test <= c2;
        
        c_out <= std_logic_vector(c2);
        
    end process;
end architecture behavioral;
