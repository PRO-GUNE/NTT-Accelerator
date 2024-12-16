library ieee;
use ieee.std_logic_1164.all;

entity test_MUX_2 is
end entity test_MUX_2;

architecture testbench of test_MUX_2 is
    component MUX_2 is
        port (
            sel : in std_logic;
            in0 : in std_logic_vector(11 downto 0);
            in1 : in std_logic_vector(11 downto 0);
            c_out : out std_logic_vector(11 downto 0)
        );
    end component MUX_2;

    signal sel : std_logic;
    signal in0 : std_logic_vector(11 downto 0);
    signal in1 : std_logic_vector(11 downto 0);
    signal c_out : std_logic_vector(11 downto 0);

begin
    UUT: MUX_2 
        port map(
            sel => sel, 
            in0 => in0, 
            in1 => in1, 
            c_out => c_out
        );

    process
    begin
    -- Test case 1: sel = '0', in0 = "000000000000", in1 = "111111111111"
    -- Expected output: c_out = "000000000000"
    sel <= '0';
    in0 <= "000000000000";
    in1 <= "111111111111";
    wait for 10 ns;
    assert c_out = "000000000000" report "Test case 1 failed" severity error;

    -- Test case 2: sel = '1', in0 = "000000000000", in1 = "111111111111"
    -- Expected output: c_out = "111111111111"
    sel <= '1';
    in0 <= "000000000000";
    in1 <= "111111111111";
    wait for 10 ns;
    assert c_out = "111111111111" report "Test case 2 failed" severity error;

    -- Test case 3: sel = '1', in0 = "101010101010", in1 = "010101010101"
    -- Expected output: c_out = "010101010101"
    sel <= '1';
    in0 <= "101010101010";
    in1 <= "010101010101";
    wait for 10 ns;
    assert c_out = "010101010101" report "Test case 3 failed" severity error;

    -- Test case 4: sel = '0', in0 = "111111111111", in1 = "000000000000"
    -- Expected output: c_out = "111111111111"
    sel <= '0';
    in0 <= "111111111111";
    in1 <= "000000000000";
    wait for 10 ns;
    assert c_out = "111111111111" report "Test case 4 failed" severity error;
    wait for 10 ns;

    end process;

end architecture testbench;