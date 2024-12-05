library ieee;
use ieee.std_logic_1164.all;

entity test_NTT_CT is
end test_NTT_CT;

architecture testbench of test_NTT_CT is
    -- Constants
    constant ADDR_SIZE : integer := 6;
    constant DATA_SIZE : integer := 48;
    
    -- Clock signal
    signal clk       : std_logic := '0';

    -- NTT Core Signals
    signal mode : std_logic_vector(1 downto 0) := (others => '0');
    signal reset : std_logic := '0';
    signal enable : std_logic := '1';
    signal data_in : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');
    signal BF_out : std_logic_vector(DATA_SIZE-1 downto 0);

    -- Twiddle ROM Signals
    signal addr_00, addr_10, addr_11 : std_logic_vector(6 downto 0);
    signal twiddle_00, twiddle_10, twiddle_11: std_logic_vector(11 downto 0);

    -- RAM Signals
    signal addr1     : std_logic_vector(ADDR_SIZE-1 downto 0) := (others => '0');
    signal addr2     : std_logic_vector(ADDR_SIZE-1 downto 0) := (others => '0');
    signal write_en  : std_logic := '0';
    signal data_in0  : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');
    signal data_in_mode : std_logic := '0';
    signal data_out  : std_logic_vector(DATA_SIZE-1 downto 0);

    -- Component instantiation

    -- Twiddle ROM Component
    component TWIDDLE_ROM
        port(
            clk : in std_logic;
            en : in std_logic;
            addr_00 : in std_logic_vector(6 downto 0);
            addr_10 : in std_logic_vector(6 downto 0);
            addr_11 : in std_logic_vector(6 downto 0);
            data_00 : out std_logic_vector(11 downto 0)
            data_10 : out std_logic_vector(11 downto 0)
            data_11 : out std_logic_vector(11 downto 0)
        );
    end component TWIDDLE_ROM;

    -- NTT RAM Component
    component NTT_RAM is
        generic (
            ADDR_SIZE : integer := 6;
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
    -- Instantiate the ROM
    ROM: TWIDDLE_ROM
        port map (
            clk => clk,
            en => en,
            addr_00 => addr_00,
            addr_10 => addr_10,
            addr_11 => addr_11,
            data_00 => twiddle_00,
            data_10 => twiddle_10,
            data_11 => twiddle_11
        );


    -- Instantiate the RAM
    RAM : NTT_RAM
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
            data_in1 => BF_out,
            data_in_mode => data_in_mode,
            data_out => data_out
        );

    -- Instantiate the NTT Core
    CORE: NTT_CORE
        port map (
            clk => clk,
            mode => mode,
            reset => reset,
            enable => enable,
            data_in => data_out,
            twiddle_1 => twiddle_00,
            twiddle_2 => twiddle_10,
            twiddle_3 => twiddle_11,
            BF_out => BF_out
        );

    -- Clock generation
    clk_process : process
    begin
        clk <= not clk;
        wait for 10 ns;
    end process;

    -- Main process
    

end testbench;