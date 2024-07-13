library ieee;
use ieee.std_logic_1164.all;

entity MUX_3 is
    port (
        sel : in std_logic_vector(1 downto 0);
        in0 : in std_logic_vector(11 downto 0);
        in1 : in std_logic_vector(11 downto 0);
        in2 : in std_logic_vector(11 downto 0);
        c_out : out std_logic_vector(11 downto 0)
    );
end entity MUX_3;

architecture Behavioral of MUX_3 is
begin
    process(sel, in0, in1, in2)
    begin
        case sel is
            when "00" =>
                c_out <= in0;
            when "01" =>
                c_out <= in1;
            when "10" =>
                c_out <= in2;
            when others =>
                c_out <= (others => '0');
        end case;
    end process;
end architecture Behavioral;