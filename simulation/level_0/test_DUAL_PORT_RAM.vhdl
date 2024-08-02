library ieee;
use ieee.std_logic_1164.all;

entity test_DUAL_PORT_RAM is
end entity test_DUAL_PORT_RAM;

architecture testbench of test_DUAL_PORT_RAM is
    -- Component declaration for the unit under test
    component DUAL_PORT_RAM
        generic (
            ADDR_SIZE : integer := 6;
            DATA_SIZE : integer := 48
        );
        port (
            clk : in std_logic;
            en1 : in std_logic;
            en2 : in std_logic;
            addr1 : in std_logic_vector(ADDR_SIZE-1 downto 0);
            addr2 : in std_logic_vector(ADDR_SIZE-1 downto 0);
            write_en : in std_logic;
            data_in : in std_logic_vector(DATA_SIZE-1 downto 0);
            data_out : out std_logic_vector(DATA_SIZE-1 downto 0)
        );
    end component;

    -- Signal declarations
    signal clk : std_logic := '0';
    signal addr1 : std_logic_vector(5 downto 0) := (others => '0');
    signal addr2 : std_logic_vector(5 downto 0) := (others => '0');
    signal write_en : std_logic := '0';
    signal data_in : std_logic_vector(47 downto 0) := (others => '0');
    signal data_out : std_logic_vector(47 downto 0);

begin
    -- Instantiate the unit under test
    UUT : DUAL_PORT_RAM
        port map (
            clk => clk,
            en1 => '1',
            en2 => '1',
            addr1 => addr1,
            addr2 => addr2,
            write_en => write_en,
            data_in => data_in,
            data_out => data_out
        );

    -- Clock process
    process
    begin
        clk <= not clk;
        wait for 5 ns;
    end process;

    process 
    begin
        -- Test 1: Writing data to RAM
        addr1 <= "000000";
        write_en <= '1';
        data_in <= "111100001111000011110000111100001111000011110000";
        wait for 100 ns;
        assert data_out = data_in report "Test 1 failed: Data read from RAM does not match the written data.";

        -- Test 2: Reading data from RAM
        addr2 <= "000000";
        assert data_out = "111100001111000011110000111100001111000011110000" report "Test 2 failed: Data read from RAM does not match the expected data.";
        wait for 100 ns;

        -- Test 3: Writing disabled write
        addr1 <= "000000";
        write_en <= '0';
        data_in <= "111100001111000011110000111100001111000011110001";
        wait for 100 ns;
        
        addr2 <= "000000";
        assert data_out = "111100001111000011110000111100001111000011110000" report "Test 3 failed: Write occurs even when write_en is disabled.";
        wait for 100 ns;

        -- Test 4: Writing and reading data with different addresses
        addr1 <= "000001";
        addr2 <= "000000";
        write_en <= '1';
        data_in <= "111100001111000011110000111100001111000011110001";
        wait for 100 ns;
        assert data_out = "111100001111000011110000111100001111000011110000" report "Test 4 failed: Data read from RAM does not match the expected data.";
        
        -- Test 5: Simultaneous read and write operations
        addr2 <= "000001";
        wait for 100 ns;
        assert data_out = "111100001111000011110000111100001111000011110001" report "Test 5 failed: Simultaneous read and write operations are not working as expected.";

        -- Test 6: Writing and reading data with same address
        addr1 <= "000001";
        write_en <= '1';
        data_in <= "111100001111000011110000111100001111000011110000";
        wait for 100 ns;
        assert data_out = "111100001111000011110000111100001111000011110000" report "Test 6 failed: Data read from RAM does not match the expected data.";
    
        wait;

    end process;
end architecture testbench;