library ieee;
use ieee.std_logic_1164.all;

entity test_MUX_2_RAM is
end entity test_MUX_2_RAM;

architecture testbench of test_MUX_2_RAM is
    constant DATA_SIZE : integer := 48;
    
    signal sel : std_logic;
    signal in0 : std_logic_vector(DATA_SIZE-1 downto 0);
    signal in1 : std_logic_vector(DATA_SIZE-1 downto 0);
    signal c_out : std_logic_vector(DATA_SIZE-1 downto 0);
begin
    UUT: entity work.MUX_2_RAM
        generic map (
            DATA_SIZE => DATA_SIZE
        )
        port map (
            sel => sel,
            in0 => in0,
            in1 => in1,
            c_out => c_out
        );
        

    stimulation: process
    begin
        -- Test case 1
        sel <= '0';
        in0 <= "010101010101010101010101010101010101010101010101";
        in1 <= "111111111111111111111111111111111111111111111111";
        wait for 10 ns;
        assert c_out = in0 report "Test case 1 failed" severity error;

        -- Test case 2
        sel <= '1';
        in0 <= "010101010101010101010101010101010101010101010101";
        in1 <= "111111111111111111111111111111111111111111111111";
        wait for 10 ns;
        assert c_out = in1 report "Test case 2 failed" severity error;
        wait;
    end process;
    
    -- Add more test cases here
    
end architecture testbench;