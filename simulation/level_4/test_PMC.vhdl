library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PMC_TB is
end PMC_TB;

architecture Behavioral of PMC_TB is
    -- Component Declaration
    component PMC
        port(
            clk : in std_logic;
            reset : in std_logic;
            SW : in STD_LOGIC_VECTOR(15 downto 0);
            AN : out STD_LOGIC_VECTOR(3 downto 0);
            SEG : out STD_LOGIC_VECTOR(6 downto 0);
            LED : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

    -- Test Signals
    signal clk_tb : std_logic := '0';
    signal reset_tb : std_logic := '0';
    signal enable_tb, LED_tb : std_logic_vector(15 downto 0) := (others => '0');
    signal AN_tb : STD_LOGIC_VECTOR(3 downto 0);
    signal SEG_tb : STD_LOGIC_VECTOR(6 downto 0);

    -- Clock period definitions
    constant CLK_PERIOD : time := 10 ns;

    -- Test status signals
    signal test_status : integer := 0;
    
begin
    -- Instantiate the Unit Under Test (UUT)
    UUT: PMC port map (
        clk => clk_tb,
        reset => reset_tb,
        SW => enable_tb,
        LED => LED_tb,
        AN => AN_tb,
        SEG => SEG_tb
    );

    -- Clock process
    clk_process: process
    begin
        clk_tb <= '0';
        wait for CLK_PERIOD/2;
        clk_tb <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize test status
        test_status <= 0;
        wait for CLK_PERIOD*2;

        -- Test Case 1: Reset Test
        test_status <= 1;
        reset_tb <= '1';
        wait for CLK_PERIOD*2;
        reset_tb <= '0';
        assert AN_tb = "1110" report "Reset test failed for AN signals" severity error;
        wait for CLK_PERIOD*2;

        -- Test Case 2: Enable Test
        test_status <= 2;
        enable_tb <= "0000000000000001";
        wait for CLK_PERIOD*4;
        -- Check if seven segment display is active (at least one anode should be low)
        assert AN_tb = "1110" or AN_tb = "1101" or AN_tb = "1011" or AN_tb = "0111" report "Enable test failed - Display not active" severity error;
        wait for CLK_PERIOD*4;

        -- Test Case 3: Operation Test
        test_status <= 3;
        -- Let the system run for several clock cycles to perform operations
        wait for CLK_PERIOD*20;

        -- Test Case 5: Reset during operation
        test_status <= 4;
        enable_tb <= "0000000000000001";
        wait for CLK_PERIOD*4;
        reset_tb <= '1';
        wait for CLK_PERIOD*2;
        reset_tb <= '0';
        assert AN_tb = "1110" report "Reset during operation failed" severity error;

        -- Test Case 6: Long running operation
        test_status <= 6;
        enable_tb <= "0000000000000001";
        wait for CLK_PERIOD*100;  -- Let it run for a while
        -- Add assertions to verify long-term stability

        -- End simulation
        test_status <= 7;
        assert false report "Test Complete" severity note;
        wait;
    end process;

    -- Monitor process to check for timing violations
    monitor_proc: process
    begin
        wait for CLK_PERIOD;
        while true loop
            if enable_tb = "0000000000000001" then
                -- Check for timing violations or unexpected behavior
                assert AN_tb'stable(CLK_PERIOD/4) report "Display changing too rapidly" severity warning;
            end if;
            wait for CLK_PERIOD;
        end loop;
    end process;

    -- Optional: Process to monitor and display test progress
    progress_monitor: process(test_status)
    begin
        case test_status is
            when 0 => report "Initializing tests..." severity note;
            when 1 => report "Running Reset Test" severity note;
            when 2 => report "Running Enable Test" severity note;
            when 3 => report "Running Operation Test" severity note;
            when 4 => report "Running Disable Test" severity note;
            when 5 => report "Running Reset During Operation Test" severity note;
            when 6 => report "Running Long Term Operation Test" severity note;
            when 7 => report "All Tests Completed" severity note;
            when others => report "Unknown test state" severity warning;
        end case;
    end process;

end Behavioral;