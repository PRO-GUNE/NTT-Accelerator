library ieee;
use ieee.std_logic_1164.all;

entity test_REG_16 is
end entity test_REG_16;

architecture testbench of test_REG_16 is
    -- Component declaration
    component REG_16
        port (
            clk : in std_logic;
            reset : in std_logic;
            enable : in std_logic;
            data_in : in std_logic_vector(15 downto 0);
            data_out : out std_logic_vector(15 downto 0)
        );
    end component REG_16;

    -- Signal declarations
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal enable : std_logic := '0';
    signal data_in : std_logic_vector(15 downto 0) := (others => '0');
    signal data_out : std_logic_vector(15 downto 0);

begin
    -- Instantiate the REG_16 component
    UUT: REG_16
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
    process
    begin
        -- Test case 1: Reset
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        wait for 10 ns;
        assert data_out = "0000000000000000" report "Test case 1 failed" severity error;

        -- Test case 2: Enable
        enable <= '1';
        wait for 10 ns;
        data_in <= "0000101010101010";
        wait for 10 ns;
        assert data_out = "0000101010101010" report "Test case 2 failed" severity error;

        -- Test case 3: No Reset, No Enable
        wait for 10 ns;
        data_in <= "0000111100001111";
        wait for 10 ns;
        assert data_out = "0000111100001111" report "Test case 3 failed" severity error;

        -- Test case 4: No Enable, Sending in value
        enable <= '0';
        wait for 10 ns;
        data_in <= "0000101010101010";
        wait for 10 ns;
        assert data_out = "0000111100001111" report "Test case 4 failed" severity error;

        -- Test case 5: Reset after setting value
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        wait for 10 ns;
        assert data_out = "0000000000000000" report "Test case 5 failed" severity error;

        wait;

    end process;

end architecture testbench;