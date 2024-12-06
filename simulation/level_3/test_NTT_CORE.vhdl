library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity test_NTT_CORE is
end test_NTT_CORE;

architecture testbench of test_NTT_CORE is
    signal clk : std_logic := '0';
    signal mode : std_logic_vector(7 downto 0) := (others => '0');
    signal reset : std_logic := '0';
    signal enable : std_logic := '1';
    signal write_en : std_logic := '1';
    signal data_in : std_logic_vector(47 downto 0) := (others => '0');
    signal twiddle_1 : std_logic_vector(11 downto 0) := (others => '0');
    signal twiddle_2 : std_logic_vector(11 downto 0) := (others => '0');
    signal twiddle_3 : std_logic_vector(11 downto 0) := (others => '0');
    signal BF_out : std_logic_vector(47 downto 0);

    component NTT_CORE is
        port (
            clk : in std_logic;
            mode : in std_logic_vector(7 downto 0);
            reset : in std_logic;
            enable : in std_logic;
            write_en : in std_logic;
            data_in : in std_logic_vector(47 downto 0);
            twiddle_1 : in std_logic_vector(11 downto 0);
            twiddle_2 : in std_logic_vector(11 downto 0);
            twiddle_3 : in std_logic_vector(11 downto 0);
            BF_out : out std_logic_vector(47 downto 0)
        );
    end component NTT_CORE;

begin   
    -- Instantiate the Unit Under Test (UUT)
    uut: NTT_CORE
        port map (
            clk => clk,
            mode => mode,
            reset => reset,
            enable => enable,
            write_en => write_en,
            data_in => data_in,
            twiddle_1 => twiddle_1,
            twiddle_2 => twiddle_2,
            twiddle_3 => twiddle_3,
            BF_out => BF_out
        );

    -- Clock generation
    clk_process : process
    begin
        clk <= not clk;
        wait for 10 ns;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        wait for 10 ns;

        -- Test case 1: Apply some data and twiddle factors
        data_in <= "000000000000000000000000000000000000000000000000";
        twiddle_1 <= "000000000001";
        twiddle_2 <= "000000000001";
        twiddle_3 <= "000000000001";
        wait for 200 ns;

        -- Test case 3: Change mode and apply different data
        mode <= "01010101";
        data_in <= "000000000000000000000000000000101010101010101010";
        twiddle_1 <= "000000000010";
        twiddle_2 <= "000000000010";
        twiddle_3 <= "000000000010";
        wait for 200 ns;

        -- Test case 3: Change mode and apply different data
        mode <= "10101010";
        data_in <= "000000000000000000000000000000101010101010101010";
        twiddle_1 <= "000000000010";
        twiddle_2 <= "000000000010";
        twiddle_3 <= "000000000010";
        wait for 200 ns;

        -- End of simulation
        wait;
    end process;

end testbench;