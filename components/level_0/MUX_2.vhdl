library ieee;
use ieee.std_logic_1164.all;

entity MUX_2 is
    port (
        sel : in std_logic;
        in0 : in std_logic_vector(11 downto 0);
        in1 : in std_logic_vector(11 downto 0);
        c_out : out std_logic_vector(11 downto 0)
    );
end entity MUX_2;

architecture Behavioral of MUX_2 is
begin
    process(sel, in0, in1)
    begin
        if sel = '0' then
            c_out <= in0;
        else
            c_out <= in1;
        end if;
    end process;
end architecture Behavioral;