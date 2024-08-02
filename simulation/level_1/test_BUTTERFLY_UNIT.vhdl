library ieee;
use ieee.std_logic_1164.all;

entity test_BUTTERFLY_UNIT is
end entity test_BUTTERFLY_UNIT;

architecture testbench of test_BUTTERFLY_UNIT is

    -- Import the entity and architecture of the BUTTERFLY_UNIT module
    component BUTTERFLY_UNIT
        port (
            clk : in std_logic;
            mode : in std_logic_vector(1 downto 0); 
            u_in : in std_logic_vector(11 downto 0);
            v_in : in std_logic_vector(11 downto 0);
            twiddle : in std_logic_vector(11 downto 0);
            u_out : out std_logic_vector(11 downto 0);
            v_out : out std_logic_vector(11 downto 0)
        );
    end component BUTTERFLY_UNIT;

    -- Declare signals for testbench
    signal clk : std_logic := '0';
    signal mode : std_logic_vector(1 downto 0) := (others => '0');
    signal u_in : std_logic_vector(11 downto 0) := (others => '0');
    signal v_in : std_logic_vector(11 downto 0) := (others => '0');
    signal twiddle : std_logic_vector(11 downto 0) := (others => '0');
    signal u_out : std_logic_vector(11 downto 0);
    signal v_out : std_logic_vector(11 downto 0);

begin
    -- Instantiate the BUTTERFLY_UNIT module
    dut: BUTTERFLY_UNIT port map (
        clk => clk,
        mode => mode,
        u_in => u_in,
        v_in => v_in,
        twiddle => twiddle,
        u_out => u_out,
        v_out => v_out
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
        mode <= "00";
        u_in <= "000000000000";
        v_in <= "000000000000";
        twiddle <= "000000000000";
        wait for 10 ns;
        assert u_out = "000000000000" report "Test 1 failed for u_out" severity error;
        assert v_out = "000000000000" report "Test 1 failed for v_out" severity error;

        -- Test 2: Random inputs
        mode <= "01";
        u_in <= "110011001100";
        v_in <= "101010101010";
        twiddle <= "111100001111";
        wait for 10 ns;
        assert u_out = "010101010101" report "Test 2 failed for u_out" severity error;
        assert v_out = "001100110011" report "Test 2 failed for v_out" severity error;

        -- Test 3: All inputs set to '1'
        mode <= "01";
        u_in <= "111111111111";
        v_in <= "111111111111";
        twiddle <= "111111111111";
        wait for 10 ns;
        assert u_out = "111111111111" report "Test 3 failed for u_out" severity error;
        assert v_out = "111111111111" report "Test 3 failed for v_out" severity error;

    end process;

end architecture testbench;