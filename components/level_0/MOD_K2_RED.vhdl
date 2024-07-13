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
        variable c_l, c_l' : unsigned(7 downto 0);
        variable c_h : unsigned(23 downto 8);
        variable c_h' : unsigned(15 downto 8);
        variable c', c'' : unsigned(15 downto 0);
    begin        
        c_l := unsigned(c_in(7 downto 0));
        c_h := unsigned(c_in(23 downto 8));
        c' := unsigned((c_h - c_l << 3) + (c_l << 2 - c_l)(15 downto 0));
        
        c_l' := unsigned(c'(7 downto 0));
        c_h' := unsigned(c'(15 downto 8));
        c'' := unsigned((c_h' - c_l' << 3) + (c_l' << 2 - c_l')(11 downto 0));

        c_out <= std_logic_vector(c'');
    end process;
end architecture behavioral;
