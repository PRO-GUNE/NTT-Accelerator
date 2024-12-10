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
    signal sel : std_logic_vector(1 downto 0) := (others => '0');
    signal data : std_logic_vector(47 downto 0) := (others => '0');
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
            sel : in std_logic_vector(1 downto 0);
            data_in: in std_logic_vector(47 downto 0);
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
            sel => sel,
            data_in => data,
            twiddle_1 => twiddle_1,
            twiddle_2 => twiddle_2,
            twiddle_3 => twiddle_3,
            BF_out => BF_out
        );

    -- Clock generation
    clk_process : process
    begin
        clk <= not clk;
        wait for 5 ns;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- reset
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        wait for 10 ns;

        -- Test case 1: u +/- vw mode
        mode <= "00000000";
        twiddle_1 <= "101000001011"; --2571 (w^64 * k^-2 mod 3329)
        twiddle_2 <= "101110011010"; --2970 (w^32 * k^-2 mod 3329)
        twiddle_3 <= "011100010100"; --1812 (w^96 * k^-2 mod 3329)

        -- a_96|a_64|a_32|a_0
        data(11 downto 0) <= "000000000000"; -- 0
        data(23 downto 12) <= "000001000000"; -- 64
        data(35 downto 24) <= "000010000000"; -- 128
        data(47 downto 36) <= "000011000000"; -- 192
        wait for 10 ns;
    
        -- a_104|a_72|a_40|a_8
        data(11 downto 0) <= "000000010000"; -- 16
        data(23 downto 12) <= "000001010000"; -- 80
        data(35 downto 24) <= "000010010000"; -- 144
        data(47 downto 36) <= "000011010000"; -- 208
        wait for 10 ns;

        -- a_112|a_80|a_48|a_16
        data(11 downto 0) <= "000000100000"; -- 32
        data(23 downto 12) <= "000001100000"; -- 96
        data(35 downto 24) <= "000010100000"; -- 160
        data(47 downto 36) <= "000011100000"; -- 224
        wait for 10 ns;

        -- a_120|a_88|a_56|a_24
        data(11 downto 0) <= "000000110000"; -- 48
        data(23 downto 12) <= "000001110000"; -- 112
        data(35 downto 24) <= "000010110000"; -- 176
        data(47 downto 36) <= "000011110000"; -- 240
        wait for 10 ns;

        wait for 50 ns; -- pipeline latency

        -- Now BUF_0 should be filled
        sel <= "00";
        assert BF_out = "010001110001101010100110001111011010101000001111" report "Test 1 failed for data_out" severity error;
        wait for 10 ns;

        -- BUF_1
        sel <= "01";
        assert BF_out <= "011010011001010100110101001111010001001001101101" report "Test 2 failed for data_out" severity error;
        wait for 10 ns;
        
        -- BUF_3
        sel <= "10";
        assert BF_out <= "001101100011010010100111010111101011011100101111" report "Test 3 failed for data_out" severity error;
        wait for 10 ns;
        
        -- BUF_4
        sel <= "11";
        assert BF_out <= "110001010101011000000000110010101100011001010111" report "Test 4 failed for data_out" severity error;
        wait for 10 ns;
        
        -- End of simulation
        wait;
    end process;

end testbench;