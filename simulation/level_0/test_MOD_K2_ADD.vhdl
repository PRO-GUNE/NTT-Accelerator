library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_MOD_K2_RED is
end entity test_MOD_K2_RED;

architecture testbench of test_MOD_K2_RED is
    component MOD_K2_RED is
        port (
            c_in : in std_logic_vector(23 downto 0);
            c_out : out std_logic_vector(15 downto 0)
        );
    end component MOD_K2_RED;

    signal c_in : std_logic_vector(23 downto 0);
    signal c_out : std_logic_vector(15 downto 0);
begin
    UUT: MOD_K2_RED
    port map (
        c_in => c_in,
        c_out => c_out
    );

    process begin
    -- Test 1: All zeros
    c_in <= "000000000000000000000000";
    wait for 100 ns;
    assert c_out = "0000000000000000" report "Test 1 failed" severity error;

    -- Test 2: Random values
    c_in <= "001010101010101010101010";
    wait for 100 ns;
    assert c_out = "0000110010111011" report "Test 2 failed" severity error;

    -- Test 3: Random values
    c_in <= "000011001100110011001100";
    wait for 100 ns;
    assert c_out = "0000011101010011" report "Test 3 failed" severity error;
    
    -- Test 4: Random values
    c_in <= "000000000000011001000110"; -- 1606 -> 1765
    wait for 100 ns;
    assert c_out = "0000011011100101" report "Test 4 failed" severity error;
    
    -- End simulation
    wait;
    end process;

end architecture testbench;