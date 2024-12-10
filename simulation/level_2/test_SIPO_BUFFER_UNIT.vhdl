library ieee;
use ieee.std_logic_1164.all;

entity test_SIPO_BUFFER_UNIT is
end test_SIPO_BUFFER_UNIT;

architecture testbench of test_SIPO_BUFFER_UNIT is
    component SIPO_BUFFER_UNIT is
        port (
            clk : in std_logic;
            reset : in std_logic;
            enable : in std_logic;
            sel : in std_logic_vector(1 downto 0);
            data_in_0 : in std_logic_vector(11 downto 0);
            data_in_1 : in std_logic_vector(11 downto 0);
            data_in_2 : in std_logic_vector(11 downto 0);
            data_in_3 : in std_logic_vector(11 downto 0);
            data_out : out std_logic_vector(47 downto 0)
        );
    end component SIPO_BUFFER_UNIT;

    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal enable : std_logic := '0';
    signal sel : std_logic_vector(1 downto 0) := (others => '0');
    signal data_in_0 : std_logic_vector(11 downto 0) := (others => '0');
    signal data_in_1 : std_logic_vector(11 downto 0) := (others => '0');
    signal data_in_2 : std_logic_vector(11 downto 0) := (others => '0');
    signal data_in_3 : std_logic_vector(11 downto 0) := (others => '0');
    signal data_out : std_logic_vector(47 downto 0) := (others => '0');

begin
    UUT : SIPO_BUFFER_UNIT
        port map (
            clk => clk,
            reset => reset,
            enable => enable,
            sel => sel,
            data_in_0 => data_in_0,
            data_in_1 => data_in_1,
            data_in_2 => data_in_2,
            data_in_3 => data_in_3,
            data_out => data_out
        );

    clk_process : process
    begin
        clk <= not clk;
        wait for 5 ns;
    end process;
    
    process
    begin
        -- reset
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        wait for 10 ns;

        -- All inputs and outputs set to '0'
        enable <= '1';
        data_in_0 <= "000000000001";
        data_in_1 <= "000000000010";
        data_in_2 <= "000000000100";
        data_in_3 <= "000000001000";
        wait for 40 ns; 
        
        -- Test 1: Random inputs
        sel <= "00";
        wait for 10 ns;
        assert data_out = "000000000001000000000001000000000001000000000001" report "Test 1 failed for data_out" severity error;
        
        sel <= "01";
        wait for 10 ns;
        assert data_out = "000000000010000000000010000000000010000000000010" report "Test 2 failed for data_out" severity error;
        
        sel <= "10";
        wait for 10 ns;
        assert data_out = "000000000100000000000100000000000100000000000100" report "Test 3 failed for data_out" severity error;
        
        sel <= "11";
        wait for 10 ns;
        assert data_out = "000000001000000000001000000000001000000000001000" report "Test 4 failed for data_out" severity error;
        wait;

    end process;

end architecture testbench;
