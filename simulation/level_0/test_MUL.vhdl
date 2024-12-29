library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_MUL is
end entity test_MUL;

architecture testbench of test_MUL is
    component MUL is
        port (
            a : in std_logic_vector(11 downto 0);
            b : in std_logic_vector(11 downto 0);
            result : out std_logic_vector(23 downto 0)
        );
    end component MUL;

    signal a_in, b_in : std_logic_vector(11 downto 0);
    signal result_out : std_logic_vector(23 downto 0);

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
    wait for 20 ns;
    assert result_out = "000000000000000000000010" report "Test case 1 failed" severity error;
    

    -- Test case 2: Multiplication of zero and a positive number
    a_in <= "000000000000"; -- 0
    b_in <= "000000000010"; -- 2
    wait for 20 ns;
    assert result_out = "000000000000000000000000" report "Test case 2 failed" severity error;


    -- Test case 3: Multiplication of two large positive numbers
    a_in <= "011111111111"; -- 2047
    b_in <= "011111111111"; -- 2047
    wait for 20 ns;
    assert result_out = "001111111111000000000001" report "Test case 3 failed" severity error;
    wait for 20 ns;

    -- Test case 4: Multiplication of specific test case
    a_in <= "101011011111"; -- 2783
    b_in <= "000000010001"; -- 17
    wait for 20 ns;
    assert result_out = "000000001011100011001111" report "Test case 4 failed" severity error;
    wait for 20 ns;
    end process;

end architecture testbench;