-- Include the REG_12 component
library ieee;
use ieee.std_logic_1164.all;

entity test_BUFFER_N is
end entity test_BUFFER_N;
    
architecture testbench of test_BUFFER_N is

    component BUFFER_N
        generic (
            N : integer := 4 -- Number of REG_12 instances
        );
        port (
            clk : in std_logic;
            reset : in std_logic;
            enable : in std_logic;
            data_in : in std_logic_vector(15 downto 0);
            data_out : out std_logic_vector(63 downto 0)
        );
    end component BUFFER_N;

    -- Declare signals for testbench
    signal data_in : std_logic_vector(15 downto 0) := (others => '0');
    signal data_out : std_logic_vector(63 downto 0);
    signal enable : std_logic := '0';
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';

begin
    
    -- Instantiate the BUFFER_N module
    UUT: BUFFER_N
        generic map(
            N => 5 -- Number of REG_12 instances
        )
        port map (
            data_in => data_in,
            data_out => data_out,
            reset => reset,
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
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        wait for 10 ns;

        -- Test 1: All inputs and outputs set to '0'
        data_in <= "0000000000000000";
        enable <= '0';
        wait for 10 ns;
        assert data_out = "0000000000000000000000000000000000000000000000000000000000000000" report "Test 1 failed for data_out" severity error;

        -- Test 2: All inputs set to '1'
        enable <= '1';
        data_in <= "0000111111111111";
        wait for 10 ns;
        data_in <= "0000101010101010";
        wait for 10 ns;
        data_in <= "0000010101010101";
        wait for 10 ns;
        data_in <= "0000111100001111";
        wait for 10 ns;
        
        -- Test 3: Random inputs
        data_in <= "0000000011110000";
        wait for 10 ns;
        assert data_out = "0000111100001111000001010101010100001010101010100000111111111111" report "Test 2 failed for data_out" severity error;
        
        -- Test 4: Random inputs
        data_in <= "0000000000000000";
        wait for 10 ns;
        assert data_out = "0000000011110000000011110000111100000101010101010000101010101010" report "Test 3 failed for data_out" severity error;
        
        wait for 10 ns;
        assert data_out = "0000000000000000000000001111000000001111000011110000010101010101" report "Test 4 failed for data_out" severity error;
        
        wait;

    end process;

end testbench;