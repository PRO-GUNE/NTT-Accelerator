library ieee;
use ieee.std_logic_1164.all;

entity test_NTT_RAM is
end test_NTT_RAM;

architecture testbench of test_NTT_RAM is
    -- Constants
    constant ADDR_SIZE : integer := 5;
    constant DATA_SIZE : integer := 48;
    
    -- Signals
    signal clk       : std_logic := '0';
    signal addr1     : std_logic_vector(ADDR_SIZE-1 downto 0) := (others => '0');
    signal addr2     : std_logic_vector(ADDR_SIZE-1 downto 0) := (others => '0');
    signal write_en  : std_logic := '0';
    signal data_in0  : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');
    signal data_in1  : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');
    signal data_in_mode : std_logic := '0';
    signal data_out  : std_logic_vector(DATA_SIZE-1 downto 0);
    
    -- Component instantiation
    component NTT_RAM is
        generic (
            ADDR_SIZE : integer := 5;
            DATA_SIZE : integer := 48
        );
        port (
            clk       : in  std_logic;
            addr1     : in  std_logic_vector(ADDR_SIZE-1 downto 0);
            addr2     : in  std_logic_vector(ADDR_SIZE-1 downto 0);
            write_en  : in  std_logic;
            data_in0  : in  std_logic_vector(DATA_SIZE-1 downto 0);
            data_in1  : in  std_logic_vector(DATA_SIZE-1 downto 0);
            data_in_mode : in std_logic;
            data_out  : out std_logic_vector(DATA_SIZE-1 downto 0)
        );
    end component NTT_RAM;
    
begin
    -- Instantiate the UUT
    UUT : NTT_RAM
        generic map (
            ADDR_SIZE => ADDR_SIZE,
            DATA_SIZE => DATA_SIZE
        )
        port map (
            clk => clk,
            addr1 => addr1,
            addr2 => addr2,
            write_en => write_en,
            data_in0 => data_in0,
            data_in1 => data_in1,
            data_in_mode => data_in_mode,
            data_out => data_out
        );
        
    -- Clock process
    clk_process : process
    begin
        clk <= not clk;
        wait for 5 ns;
    end process;
    
    -- Stimulus process
    stimulus_process : process
    begin
        -- Test case 1
        addr1 <= "000000";
        addr2 <= "000000";
        write_en <= '1';
        data_in0 <= "111111111111111111111111111111111111111111111111";
        data_in1 <= "000000000000000000000000000000000000000000000000";
        data_in_mode <= '0';
        wait for 10 ns;
        assert data_out = data_in0 report "Test 1 failed: Data read from RAM does not match the written data.";
        
        -- Test case 2
        addr1 <= "000001";
        addr2 <= "000001";
        write_en <= '1';
        data_in0 <= "000000000000000000000000000000000000000000000000";
        data_in1 <= "111111111111111111111111111111111111111111111111";
        data_in_mode <= '1';
        wait for 10 ns;
        assert data_out = data_in1 report "Test 2 failed: Data read from RAM does not match the written data.";
        
    end process stimulus_process;

end testbench;