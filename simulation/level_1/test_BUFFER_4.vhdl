-- Include the REG_12 component
library ieee;
use ieee.std_logic_1164.all;

entity test_BUFFER_4 is
end entity test_BUFFER_4;
    
architecture testbench of test_BUFFER_4 is

    component BUFFER_4
        port (
            input_data : in std_logic_vector(11 downto 0);
            output_data : out std_logic_vector(11 downto 0);
            enable : in std_logic;
            clk : in std_logic
        );
    end component BUFFER_4;

    -- Declare signals for testbench
    signal input_data : std_logic_vector(11 downto 0) := (others => '0');
    signal output_data : std_logic_vector(11 downto 0);
    signal enable : std_logic := '0';
    signal clk : std_logic := '0';

begin
    
    -- Instantiate the BUFFER_4 module
    dut: BUFFER_4 port map (
        input_data => input_data,
        output_data => output_data,
        enable => enable,
        clk => clk
    );
    
    -- Clock process
    process
    begin
        clk <= not clk;
        wait for 5 ns;
    end process;

    process
    begin
        -- Test 1: All inputs and outputs set to '0'
        input_data <= (others => '0');
        enable <= '0';
        wait for 10 ns;
        assert output_data = (others => '0') report "Test 1 failed for output_data" severity error;

        enable <= '1';
        input_data <= (others => '1');
        wait for 10 ns;
        input_data <= "101010101010";
        wait for 10 ns;
        input_data <= "010101010101";
        wait for 10 ns;
        input_data <= "111100001111";
        wait for 10 ns;
        
        -- Test 2: All inputs set to '1'
        input_data <= (others => '0');
        assert output_data = (others => '1') report "Test 2 failed for output_data" severity error;
        wait for 10 ns;
        
        -- Test 3: Random inputs
        assert output_data = "101010101010" report "Test 3 failed for output_data" severity error;
        wait for 10 ns;
        
        -- Test 4: Random inputs
        assert output_data = "010101010101" report "Test 4 failed for output_data" severity error;
        wait for 10 ns;

        wait;

    end process;

end testbench;