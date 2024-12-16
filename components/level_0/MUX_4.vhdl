library ieee;
use ieee.std_logic_1164.all;

entity MUX_4 is
    port (
        sel : in std_logic_vector(1 downto 0);
        in0 : in std_logic_vector(47 downto 0);
        in1 : in std_logic_vector(47 downto 0);
        in2 : in std_logic_vector(47 downto 0);
        in3 : in std_logic_vector(47 downto 0);
        c_out : out std_logic_vector(47 downto 0)
    );
end entity MUX_4;

architecture behavioral of MUX_4 is
begin
    process (sel, in0, in1, in2, in3)
    begin
        case sel is
            when "00" =>
                c_out <= in0;
            when "01" =>
                c_out <= in1;
            when "10" =>
                c_out <= in2;
            when "11" =>
                c_out <= in3;
            when others =>
                c_out <= (others => 'X');
        end case;
    end process;
end architecture behavioral;