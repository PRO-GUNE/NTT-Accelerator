library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_MOD_SUB is
end entity test_MOD_SUB;

architecture Behavioral of test_MOD_SUB is
    component MOD_SUB is
        port (
            a : in std_logic_vector(11 downto 0);
            b : in std_logic_vector(11 downto 0);
            diff : out std_logic_vector(11 downto 0)
        );
    end component MOD_SUB;

    signal a : std_logic_vector(11 downto 0);
    signal b : std_logic_vector(11 downto 0);
    signal diff : std_logic_vector(11 downto 0);

begin
    UUT: MOD_SUB
        port map (
            a => a,
            b => b,
            diff => diff
        );

    process begin

    -- Test case 1: a = 0, b = 0
    a <= "000000000000";
    b <= "000000000000";
    wait for 10 ns;
    assert diff = "000000000000" report "Test case 1 failed" severity error;

    -- Test case 2: a = 100, b = 50
    a <= "000000110010";
    b <= "000000011001";
    wait for 10 ns;
    assert diff = "000000011001" report "Test case 2 failed" severity error;

    -- Test case 3: a = 500, b = 1000
    a <= "001111010100";
    b <= "011111000100";
    wait for 10 ns;
    assert diff = "010000010100" report "Test case 3 failed" severity error;

    -- End simulation
    wait;
    end process;
    
end architecture Behavioral;