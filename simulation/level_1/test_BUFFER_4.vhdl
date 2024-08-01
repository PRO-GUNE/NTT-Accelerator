-- Include the REG_12 component
library ieee;
use ieee.std_logic_1164.all;

entity test_BUFFER_4 is
end entity test_BUFFER_4;
    
architecture testbench of test_BUFFER_4 is

    component BUFFER_4
        port (
            clk : in std_logic;
            reset : in std_logic;
            enable : in std_logic;
            data_in : in std_logic_vector(11 downto 0);
            data_out : out std_logic_vector(11 downto 0)
        );
    end component BUFFER_4;

    -- Declare signals for testbench
    signal data_in : std_logic_vector(11 downto 0) := (others => '0');
    signal data_out : std_logic_vector(11 downto 0);
    signal enable : std_logic := '0';
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';

begin
    
    -- Instantiate the BUFFER_4 module
    UUT: BUFFER_4 port map (
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
        data_in <= "000000000000";
        enable <= '0';
        wait for 10 ns;
        assert data_out = "000000000000" report "Test 1 failed for data_out" severity error;

        enable <= '1';
        data_in <= "111111111111";
        wait for 10 ns;
        data_in <= "101010101010";
        wait for 10 ns;
        data_in <= "010101010101";
        wait for 10 ns;
        data_in <= "111100001111";
        wait for 10 ns;
        
        -- Test 2: All inputs set to '1'
        data_in <= "000000000000";
        assert data_out = "111111111111" report "Test 2 failed for data_out" severity error;
        wait for 10 ns;
        
        -- Test 3: Random inputs
        assert data_out = "101010101010" report "Test 3 failed for data_out" severity error;
        wait for 10 ns;
        
        -- Test 4: Random inputs
        assert data_out = "010101010101" report "Test 4 failed for data_out" severity error;
        wait for 10 ns;

        wait;

    end process;

end testbench;