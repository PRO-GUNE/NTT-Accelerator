library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity INSTRUCTION_ROM_TB is
end INSTRUCTION_ROM_TB;

architecture behavior of INSTRUCTION_ROM_TB is
    -- Component Declaration
    component INSTRUCTION_ROM
        port(
            clk : in std_logic;
            enable : in std_logic;
            write_en : out std_logic;
            data_in_mode : out std_logic;
            mode : out std_logic_vector(7 downto 0);
            sel : out std_logic_vector(1 downto 0);
            addr_00 : out std_logic_vector(6 downto 0);
            addr_10 : out std_logic_vector(6 downto 0);
            addr_11 : out std_logic_vector(6 downto 0);
            addr1 : out std_logic_vector(5 downto 0);
            addr2 : out std_logic_vector(5 downto 0)
        );
    end component;

    -- Input Signals
    signal clk : std_logic := '0';
    signal enable : std_logic := '0';

    -- Output Signals
    signal write_en : std_logic;
    signal data_in_mode : std_logic;
    signal mode : std_logic_vector(7 downto 0);
    signal sel : std_logic_vector(1 downto 0);
    signal addr_00 : std_logic_vector(6 downto 0);
    signal addr_10 : std_logic_vector(6 downto 0);
    signal addr_11 : std_logic_vector(6 downto 0);
    signal addr1 : std_logic_vector(5 downto 0);
    signal addr2 : std_logic_vector(5 downto 0);

    -- Clock period definition
    constant CLK_PERIOD : time := 10 ns;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: INSTRUCTION_ROM port map (
        clk => clk,
        enable => enable,
        write_en => write_en,
        data_in_mode => data_in_mode,
        mode => mode,
        sel => sel,
        addr_00 => addr_00,
        addr_10 => addr_10,
        addr_11 => addr_11,
        addr1 => addr1,
        addr2 => addr2
    );

    -- Clock process
    clk_process: process
    begin
        wait for CLK_PERIOD/2;
        clk <= not clk;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize
        wait for CLK_PERIOD;
        
        -- Test Case 1: Enable the ROM and check first instruction
        enable <= '1';
        wait for CLK_PERIOD*2;
        assert write_en = '0' report "Test Case 1: write_en mismatch" severity error;
        assert data_in_mode = '1' report "Test Case 1: data_in_mode mismatch" severity error;
        assert sel = "00" report "Test Case 1: sel mismatch" severity error;
        assert mode = "00000000" report "Test Case 1: mode mismatch" severity error;
        
        -- Test Case 2: Check next few instructions
        for i in 1 to 4 loop
            wait for CLK_PERIOD;
            -- Add specific assertions here based on expected values
            assert write_en = '0' report "Test Case 2: write_en mismatch at iteration " & integer'image(i) severity error;
        end loop;
        
        -- Test Case 3: Disable and re-enable
        enable <= '0';
        wait for CLK_PERIOD;
        enable <= '1';
        wait for CLK_PERIOD;
        -- Check if PC reset to 0
        assert write_en = '0' report "Test Case 3: write_en mismatch after reset" severity error;
        assert data_in_mode = '1' report "Test Case 3: data_in_mode mismatch after reset" severity error;
        
        -- Test Case 4: Run through all instructions
        for i in 1 to 16 loop
            wait for CLK_PERIOD;
            -- You can add specific assertions here for each instruction
        end loop;
        
        -- Test Case 5: Check overflow behavior
        wait for CLK_PERIOD*2;
        assert write_en = '0' report "Test Case 5: write_en mismatch at overflow" severity error;
        
        -- End simulation
        wait for CLK_PERIOD*2;
        assert false report "Test Completed Successfully" severity note;
        wait;
    end process;

end behavior;