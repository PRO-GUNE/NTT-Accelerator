library ieee;
use ieee.std_logic_1164.all;

entity test_TWIDDLE_ROM is
end entity test_TWIDDLE_ROM;

architecture testbench of test_TWIDDLE_ROM is
    -- Component declaration
    component TWIDDLE_ROM
        port(
            clk : in std_logic;
            en : in std_logic;
            addr : in std_logic_vector(6 downto 0);
            data : out std_logic_vector(11 downto 0)
        );
    end component TWIDDLE_ROM;

        -- Signal declarations
    signal clk : std_logic := '0';
    signal en : std_logic := '1';
    signal addr : std_logic_vector(6 downto 0);
    signal data : std_logic_vector(11 downto 0) := (others => '0');
    
begin
    -- Instantiate the TWIDDLE_ROM component
    UUT: TWIDDLE_ROM
        port map (
            clk => clk,
            en => en,
            addr => addr,
            data => data
        );

    -- Clock process
    process
    begin
        clk <= not clk;
        wait for 5 ns;
    end process;

    -- Test cases
    process
    begin
        -- Test 1: Read data from address 0
        addr <= "0000000";
        wait for 10 ns;
        assert data = X"011" report "Test 1 failed" severity error;

        -- Test 2: Read data from address 127
        addr <= "1111111";
        wait for 10 ns;
        assert data = X"497" report "Test 2 failed" severity error;

        -- Test 3: Read data from address 32
        addr <= "0100000";
        wait for 10 ns;
        assert data = X"ac9" report "Test 3 failed" severity error;

        -- Test 4: Read data from address 63
        addr <= "0111111";
        wait for 10 ns;
        assert data = X"86a" report "Test 4 failed" severity error;

        wait;
    end process;

end architecture testbench;