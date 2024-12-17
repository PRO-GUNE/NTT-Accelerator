library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CLK_DIVIDER is
    port(
        clk_in : in std_logic;
        reset : in std_logic;
        clk_out: out std_logic
    );
end CLK_DIVIDER;

architecture behavioral of CLK_DIVIDER is
    signal int_clk : std_logic := '0';
begin
    process(clk_in)
        variable count : integer := 0;
        constant MODULO : integer := 1000; -- = 1 for simulation
    begin
        if rising_edge(clk_in) then
            count := count + 1;

            if count = MODULO then
                count := 0;
                int_clk <= not int_clk;
                clk_out <= int_clk;
            end if;

            if reset = '1' then
                count := 0;
                int_clk <= '0';
            end if;
        end if;
    end process;
end behavioral;