library IEEE;
use ieee.std_logic_1164.all;

entity test_MUX_4 is
end test_MUX_4;

architecture Behavioral of test_MUX_4 is
    component MUX_4 is
        port (
            sel : in std_logic_vector(1 downto 0);
            in0 : in std_logic_vector(11 downto 0);
            in1 : in std_logic_vector(11 downto 0);
            in2 : in std_logic_vector(11 downto 0);
            in3 : in std_logic_vector(11 downto 0);
            c_out : out std_logic_vector(11 downto 0)
        );
    end component MUX_4;

    signal sel : std_logic_vector(1 downto 0);
    signal in0 : std_logic_vector(11 downto 0);
    signal in1 : std_logic_vector(11 downto 0);
    signal in2 : std_logic_vector(11 downto 0);
    signal in3 : std_logic_vector(11 downto 0);
    signal c_out : std_logic_vector(11 downto 0);

begin
    UUT: MUX_4 
        port map(
            sel => sel, 
            in0 => in0, 
            in1 => in1, 
            in2 => in2, 
            in3 => in3, 
            c_out => c_out
        );

    process begin

    -- Test 1: Select input 0
    sel <= "00";
    in0 <= "010101010101";
    in1 <= "000000000000";
    in2 <= "111111111111";
    in3 <= "101010101010";
    wait for 10 ns;
    assert c_out = "010101010101" report "Test 1 failed" severity error;

    -- Test 2: Select input 1
    sel <= "01";
    in0 <= "010101010101";
    in1 <= "000000000000";
    in2 <= "111111111111";
    in3 <= "101010101010";
    wait for 10 ns;
    assert c_out = "000000000000" report "Test 2 failed" severity error;

    -- Test 3: Select input 2
    sel <= "10";
    in0 <= "010101010101";
    in1 <= "000000000000";
    in2 <= "111111111111";
    in3 <= "101010101010";
    wait for 10 ns;
    assert c_out = "111111111111" report "Test 3 failed" severity error;

    -- Test 4: Select input 3
    sel <= "11";
    in0 <= "010101010101";
    in1 <= "000000000000";
    in2 <= "111111111111";
    in3 <= "101010101010";
    wait for 10 ns;
    assert c_out = "101010101010" report "Test 4 failed" severity error;

    -- Test 5: Select invalid input
    sel <= "10";
    in0 <= "010101010101";
    in1 <= "000000000000";
    in2 <= "111111111111";
    in3 <= "101010101010";
    wait for 10 ns;
    assert c_out = (others => 'X') report "Test 5 failed" severity error;

    wait;
    end process;

end architecture Behavioral;