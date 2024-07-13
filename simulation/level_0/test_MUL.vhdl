library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_MUL is
end entity test_MUL;

architecture Behavioral of test_MUL is
    component MUL is
        port (
            a : in  unsigned(11 downto 0);
            b : in  unsigned(11 downto 0);
            result : out unsigned(23 downto 0)
        );
    end component MUL;

    signal a_in, b_in : unsigned(11 downto 0);
    signal result_out : unsigned(23 downto 0);

begin
    UUT: MUL
        port map (
            a => a_in,
            b => b_in,
            result => result_out
        );

    
    process
    begin
    -- Test case 1: Multiplication of two positive numbers
    a_in <= "000000000001"; -- 1
    b_in <= "000000000010"; -- 2
    wait for 10 ns;
    assert result_out = "000000000000000000000010" report "Test case 1 failed" severity error;
    
    -- Test case 2: Multiplication of a positive and a negative number
    a_in <= "000000000011"; -- 3
    b_in <= "111111111110"; -- -2
    wait for 10 ns;
    assert result_out = "111111111111111111111100" report "Test case 2 failed" severity error;

    -- Test case 3: Multiplication of two negative numbers
    a_in <= "111111111111"; -- -1
    b_in <= "111111111110"; -- -2
    wait for 10 ns;
    assert result_out = "000000000000000000000010" report "Test case 3 failed" severity error;


    -- Test case 4: Multiplication of zero and a positive number
    a_in <= "000000000000"; -- 0
    b_in <= "000000000010"; -- 2
    wait for 10 ns;
    assert result_out = "000000000000000000000000" report "Test case 4 failed" severity error;


    -- Test case 5: Multiplication of zero and a negative number
    a_in <= "000000000000"; -- 0
    b_in <= "111111111110"; -- -2
    wait for 10 ns;
    assert result_out = "000000000000000000000000" report "Test case 5 failed" severity error;
    wait;
    end process;

end architecture Behavioral;