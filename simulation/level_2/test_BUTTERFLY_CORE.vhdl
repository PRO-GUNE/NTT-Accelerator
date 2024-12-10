library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_BUTTERFLY_CORE is
end test_BUTTERFLY_CORE;

architecture Behavioral of test_BUTTERFLY_CORE is
    signal clk : std_logic := '0';
    signal mode : std_logic_vector(7 downto 0) := "00000000";
    signal reset : std_logic := '0';
    signal enable : std_logic := '1';
    signal u1_in, u2_in, v1_in, v2_in : std_logic_vector(11 downto 0) := (others => '0');
    signal twiddle_1, twiddle_2, twiddle_3 : std_logic_vector(11 downto 0) := (others => '0');
    signal u1_out, u2_out, v1_out, v2_out : std_logic_vector(11 downto 0) := (others => '0');

    component BUTTERFLY_CORE is
        port (
            clk : in std_logic;
            mode : in std_logic_vector(7 downto 0);
            reset : in std_logic;
            enable : in std_logic;
            u1_in : in std_logic_vector(11 downto 0);
            u2_in : in std_logic_vector(11 downto 0);
            v1_in : in std_logic_vector(11 downto 0);
            v2_in : in std_logic_vector(11 downto 0);
            twiddle_1 : in std_logic_vector(11 downto 0);
            twiddle_2 : in std_logic_vector(11 downto 0);
            twiddle_3 : in std_logic_vector(11 downto 0);
            u1_out : out std_logic_vector(11 downto 0);
            u2_out : out std_logic_vector(11 downto 0);
            v1_out : out std_logic_vector(11 downto 0);
            v2_out : out std_logic_vector(11 downto 0)
        );
    end component BUTTERFLY_CORE;

begin
    uut: BUTTERFLY_CORE
        port map (
            clk => clk,
            mode => mode,
            reset => reset,
            enable => enable,
            u1_in => u1_in,
            u2_in => u2_in,
            v1_in => v1_in,
            v2_in => v2_in,
            twiddle_1 => twiddle_1,
            twiddle_2 => twiddle_2,
            twiddle_3 => twiddle_3,
            u1_out => u1_out,
            u2_out => u2_out,
            v1_out => v1_out,
            v2_out => v2_out
        );

    clk_process : process
    begin
        clk <= not clk;
        wait for 5 ns;
    end process;

    stim_proc: process
    begin
        -- reset
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        wait for 10 ns;

        -- Test case 1 - u +/- vw mode
        mode <= "00000000";
        u1_in <= "000000000000"; -- 0
        u2_in <= "000001000000"; -- 64
        v1_in <= "000010000000"; -- 128
        v2_in <= "000011000000"; -- 192
        twiddle_1 <= "101000001011"; --2571 (w^64 * k^-2 mod 3329)
        twiddle_2 <= "101110011010"; --2970 (w^32 * k^-2 mod 3329)
        twiddle_3 <= "011100010100"; --1812 (w^96 * k^-2 mod 3329)
        wait for 80 ns;
        assert u1_out = "101000001111" report "Test 1 failed for u1_out" severity error; -- 2575
        assert v1_out = "011100101111" report "Test 1 failed for v1_out" severity error; -- 1839
        assert u2_out = "001001101101" report "Test 1 failed for u2_out" severity error; -- 621
        assert v2_out = "011001010111" report "Test 1 failed for v2_out" severity error; -- 1623

        -- Test case 2 - Add/Sub mode
        mode <= "01010101";
        twiddle_1 <= "100011101101"; --2285 (w^0 * k^-2 mod 3329)
        twiddle_2 <= "100011101101"; --2285 (w^0 * k^-2 mod 3329)
        twiddle_3 <= "100011101101"; --2285 (w^0 * k^-2 mod 3329)
        wait for 80 ns;
        assert u1_out = "000110000000" report "Test 2 failed for u1_out" severity error; -- 384
        assert u2_out = "110010000001" report "Test 2 failed for u2_out" severity error; -- 3201
        assert v1_out = "110000000001" report "Test 2 failed for v1_out" severity error; -- 3073
        assert v2_out = "000000000000" report "Test 2 failed for v2_out" severity error; -- 0
        
        -- Test case 3 -  u/v mode
        mode <= "10101010";
        wait for 80 ns;
        assert u1_out = "000000000000" report "Test 3 failed for u1_out" severity error; -- 0
        assert u2_out = "000001000000" report "Test 3 failed for u2_out" severity error; -- 64
        assert v1_out = "000010000000" report "Test 3 failed for v1_out" severity error; -- 128
        assert v2_out = "000011000000" report "Test 3 failed for v2_out" severity error; -- 192

        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        wait for 10 ns;

        -- More cases for same mode 0
        mode <= "00000000";
        twiddle_1 <= "101000001011"; --2571 (w^64 * k^-2 mod 3329)
        twiddle_2 <= "101110011010"; --2970 (w^32 * k^-2 mod 3329)
        twiddle_3 <= "011100010100"; --1812 (w^96 * k^-2 mod 3329)
        u1_in <= "000000000000"; -- 0
        u2_in <= "000000000000"; -- 64
        v1_in <= "000000000000"; -- 128
        v2_in <= "000000000000"; -- 192

        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        wait for 10 ns;

        -- a_96|a_64|a_32|a_0
        u1_in <= "000000000000"; -- 0
        u2_in <= "000001000000"; -- 64
        v1_in <= "000010000000"; -- 128
        v2_in <= "000011000000"; -- 192
        wait for 10 ns;

        -- a_104|a_72|a_40|a_8
        u1_in <= "000000010000"; -- 16
        u2_in <= "000001010000"; -- 80
        v1_in <= "000010010000"; -- 144
        v2_in <= "000011010000"; -- 208
        wait for 10 ns;

        -- -- a_112|a_80|a_48|a_16
        u1_in <= "000000100000"; -- 32
        u2_in <= "000001100000"; -- 96
        v1_in <= "000010100000"; -- 160
        v2_in <= "000011100000"; -- 224
        wait for 10 ns;

        -- -- a_120|a_88|a_56|a_24
        u1_in <= "000000110000"; -- 48
        u2_in <= "000001110000"; -- 112
        v1_in <= "000010110000"; -- 176
        v2_in <= "000011110000"; -- 240
        wait for 10 ns;

        wait;
    end process stim_proc;

end Behavioral;