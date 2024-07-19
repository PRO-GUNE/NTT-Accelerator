library ieee;
use ieee.std_logic_1164.all;

entity test_MUX_3 is
end entity test_MUX_3;

architecture testbench of test_MUX_3 is
    -- Component declaration
    component MUX_3 is
        port (
            sel : in std_logic_vector(1 downto 0);
            in0 : in std_logic_vector(11 downto 0);
            in1 : in std_logic_vector(11 downto 0);
            in2 : in std_logic_vector(11 downto 0);
            c_out : out std_logic_vector(11 downto 0)
        );
    end component MUX_3;

    -- Signal declarations
    signal sel : std_logic_vector(1 downto 0);
    signal in0 : std_logic_vector(11 downto 0);
    signal in1 : std_logic_vector(11 downto 0);
    signal in2 : std_logic_vector(11 downto 0);
    signal c_out : std_logic_vector(11 downto 0);

begin
    -- Instantiate the MUX_3 component
    UUT: MUX_3 port map (
        sel => sel,
        in0 => in0,
        in1 => in1,
        in2 => in2,
        c_out => c_out
    );

    process begin

    -- Test case 1
    -- Expected output: c_out = "000000000000"
    sel <= "00";
    in0 <= "000000000000";
    in1 <= "111111111111";
    in2 <= "101010101010";
    wait for 10 ns;
    assert c_out = "000000000000" report "Test case 1 failed" severity error;

    -- Test case 2
    -- Expected output: c_out = "111111111111"
    sel <= "01";
    in0 <= "000000000000";
    in1 <= "111111111111";
    in2 <= "101010101010";
    wait for 10 ns;
    assert c_out = "111111111111" report "Test case 2 failed" severity error;
    
    -- Test case 3
    -- Expected output: c_out = "101010101010"
    sel <= "10";
    in0 <= "000000000000";
    in1 <= "111111111111";
    in2 <= "101010101010";
    wait for 10 ns;
    assert c_out = "101010101010" report "Test case 3 failed" severity error;

    -- Test case 4
    -- Expected output: c_out = "000000000000"
    sel <= "11";
    in0 <= "000000000000";
    in1 <= "111111111111";
    in2 <= "101010101010";
    wait for 10 ns;
    assert c_out = "000000000000" report "Test case 3 failed" severity error;

    wait;
    end process;

end architecture testbench;