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
            addr_00 : in std_logic_vector(6 downto 0);
            addr_10 : in std_logic_vector(6 downto 0);
            addr_11 : in std_logic_vector(6 downto 0);
            data_00 : out std_logic_vector(11 downto 0);
            data_10 : out std_logic_vector(11 downto 0);
            data_11 : out std_logic_vector(11 downto 0)
        );
    end component TWIDDLE_ROM;

        -- Signal declarations
    signal clk : std_logic := '0';
    signal en : std_logic := '1';
    signal addr_00, addr_10, addr_11 : std_logic_vector(6 downto 0);
    signal data_00, data_10, data_11 : std_logic_vector(11 downto 0) := (others => '0');
    
begin
    -- Instantiate the TWIDDLE_ROM component
    UUT: TWIDDLE_ROM
        port map (
            clk => clk,
            en => en,
            addr_00 => addr_00,
            addr_10 => addr_10,
            addr_11 => addr_11,
            data_00 => data_00,
            data_10 => data_10,
            data_11 => data_11
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
        addr_00 <= "0000000";
        addr_10 <= "0000000";
        addr_11 <= "0000000";
        wait for 10 ns;
        assert data_00 = X"8ed" report "Test 1 failed" severity error;

        -- Test 2: Read data from address 127
        addr_00 <= "1111111";
        wait for 10 ns;
        assert data_00 = X"cb3" report "Test 2 failed" severity error;

        -- Test 3: Read data from address 32
        addr_00 <= "0100000";
        wait for 10 ns;
        assert data_00 = X"4c7" report "Test 3 failed" severity error;

        -- Test 4: Read data from address 63
        addr_10 <= "0111111";
        wait for 10 ns;
        assert data_10 = X"806" report "Test 4 failed" severity error;

        wait;
    end process;

end architecture testbench;