library ieee;
use ieee.std_logic_1164.all;

entity test_DUAL_PORT_RAM is
end entity test_DUAL_PORT_RAM;

architecture testbench of test_DUAL_PORT_RAM is
    -- Component declaration for the unit under test
    component DUAL_PORT_RAM
        port (
            clk : in std_logic;
            en_1 : in std_logic;
            en_2 : in std_logic;
            addr1 : in std_logic_vector(31 downto 0);
            addr2 : in std_logic_vector(31 downto 0);
            write_en : in std_logic;
            data_in : in std_logic_vector(31 downto 0);
            data_out : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Signal declarations
    signal clk : std_logic := '0';
    signal en_1 : std_logic := '0';
    signal en_2 : std_logic := '0';
    signal addr1 : std_logic_vector(31 downto 0) := (others => '0');
    signal addr2 : std_logic_vector(31 downto 0) := (others => '0');
    signal write_en : std_logic := '0';
    signal data_in : std_logic_vector(31 downto 0) := (others => '0');
    signal data_out : std_logic_vector(31 downto 0);

begin
    -- Instantiate the unit under test
    UUT : DUAL_PORT_RAM
        port map (
            clk => clk,
            en_1 => en_1,
            en_2 => en_2,
            addr1 => addr1,
            addr2 => addr2,
            write_en => write_en,
            data_in => data_in,
            data_out => data_out
        );

    -- Test 1: Writing data to RAM
    clk <= '1';
    en_1 <= '1';
    addr1 <= "00000000000000000000000000000000";
    write_en <= '1';
    data_in <= "111100001111000011110000111100001111000011110000";
    assert data_out = data_in report "Test 1 failed: Data read from RAM does not match the written data.";

    -- Test 2: Reading data from RAM
    clk <= '1';
    en_2 <= '1';
    addr2 <= "00000000000000000000000000000000";
    assert data_out = "11110000111100001111000011110000" report "Test 2 failed: Data read from RAM does not match the expected data.";

    -- Test 3: Writing and reading data simultaneously
    clk <= '1';
    en_1 <= '1';
    en_2 <= '1';
    addr1 <= "00000000000000000000000000000000";
    addr2 <= "00000000000000000000000000000000";
    write_en <= '1';
    data_in <= "111100001111000011110000111100001111000011110000";
    assert data_out = data_in report "Test 3 failed: Data read from RAM does not match the written data.";

    -- Test 4: Writing and reading data with different addresses
    clk <= '1';
    en_1 <= '1';
    en_2 <= '1';
    addr1 <= "00000000000000000000000000000000";
    addr2 <= "00000000000000000000000000000001";
    write_en <= '1';
    data_in <= "111100001111000011110000111100001111000011110000";
    assert data_out = data_in report "Test 4 failed: Data read from RAM does not match the written data.";

end architecture testbench;