library ieee;
use ieee.std_logic_1164.all;

entity test_REG_12 is
end entity test_REG_12;

architecture test_behavioral of test_REG_12 is
    -- Component declaration
    component REG_12
        port (
            clk : in std_logic;
            reset : in std_logic;
            enable : in std_logic;
            data_in : in std_logic_vector(11 downto 0);
            data_out : out std_logic_vector(11 downto 0)
        );
    end component REG_12;

    -- Signal declarations
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal enable : std_logic := '0';
    signal data_in : std_logic_vector(11 downto 0) := (others => '0');
    signal data_out : std_logic_vector(11 downto 0);

begin
    -- Instantiate the REG_12 component
    UUT: REG_12
        port map (
            clk => clk,
            reset => reset,
            enable => enable,
            data_in => data_in,
            data_out => data_out
        );

    -- Clock process
    process
    begin
        clk <= not clk;
        wait for 5 ns;
    end process;

    -- Test cases
    -- Test case 1: Reset
    process
    begin
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        wait for 20 ns;
        assert data_out = (others => '0') report "Test case 1 failed" severity error;
        wait;
    end process;

    -- Test case 2: Enable
    process
    begin
        enable <= '1';
        wait for 10 ns;
        data_in <= "101010101010";
        wait for 20 ns;
        assert data_out = "101010101010" report "Test case 2 failed" severity error;
        wait;
    end process;

    -- Test case 3: No Reset, No Enable
    process
    begin
        wait for 10 ns;
        data_in <= "111100001111";
        wait for 20 ns;
        assert data_out = "111100001111" report "Test case 3 failed" severity error;
        wait;
    end process;

end architecture test_behavioral;