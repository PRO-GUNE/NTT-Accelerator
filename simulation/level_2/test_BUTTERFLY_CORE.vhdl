library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_BUTTERFLY_CORE is
end test_BUTTERFLY_CORE;

architecture Behavioral of test_BUTTERFLY_CORE is
    signal clk : std_logic := '0';
    signal mode : std_logic_vector(1 downto 0) := "00";
    signal u1_in, u2_in, v1_in, v2_in : std_logic_vector(11 downto 0);
    signal twiddle_1, twiddle_2, twiddle_3 : std_logic_vector(11 downto 0);
    signal u1_out, u2_out, v1_out, v2_out : std_logic_vector(11 downto 0);

    component BUTTERFLY_CORE is
        port (
            clk : in std_logic;
            mode : in std_logic_vector(1 downto 0);
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
        wait for 10 ns;
    end process;

    stim_proc: process
    begin
        -- Test case 1
        mode <= "00";
        u1_in <= "000000000001"; u2_in <= "000000000010";
        v1_in <= "000000000011"; v2_in <= "000000000100";
        twiddle_1 <= "000000000101"; twiddle_2 <= "000000000110"; twiddle_3 <= "000000000111";
        wait for 100 ns;

        -- Test case 2
        mode <= "01";
        u1_in <= "000000001000"; u2_in <= "000000001001";
        v1_in <= "000000001010"; v2_in <= "000000001011";
        twiddle_1 <= "000000001100"; twiddle_2 <= "000000001101"; twiddle_3 <= "000000001110";
        wait for 100 ns;

        -- Test case 3
        mode <= "10";
        u1_in <= "000000010000"; u2_in <= "000000010001";
        v1_in <= "000000010010"; v2_in <= "000000010011";
        twiddle_1 <= "000000010100"; twiddle_2 <= "000000010101"; twiddle_3 <= "000000010110";
        wait for 100 ns;

        wait;
    end process stim_proc;

end Behavioral;