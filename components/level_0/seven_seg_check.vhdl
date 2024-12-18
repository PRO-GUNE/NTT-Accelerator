library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seven_seg_display is
    Port ( 
        CLK100MHZ : in STD_LOGIC;         -- 100MHz clock from Nexys A7
        CPU_RESETN : in STD_LOGIC;         -- Active-low reset button
        SEG : out STD_LOGIC_VECTOR(6 downto 0);  -- Segment signals
        AN : out STD_LOGIC_VECTOR(3 downto 0);    -- Anode signals
        NUMBER : in STD_LOGIC_VECTOR(15 downto 0)    -- 16-bit input number
    );
end seven_seg_display;

architecture Behavioral of seven_seg_display is
    -- Internal signals
    signal count : unsigned(15 downto 0) := (others => '0');  -- Counter value
    signal refresh_counter : unsigned(19 downto 0);           -- Counter for display refresh
    signal digit_select : std_logic_vector(1 downto 0);       -- Current digit selection
    signal current_digit : std_logic_vector(3 downto 0);      -- Current digit to display
    signal reset : std_logic;                                 -- Internal reset signal
    
    -- Clock divider for counter
    signal slow_clock_counter : unsigned(25 downto 0) := (others => '0');
    signal slow_clock : std_logic := '0';
    
begin
    -- Invert reset signal (CPU_RESETN is active low)
    reset <= not CPU_RESETN;

    -- Clock divider process (creates approximately 1Hz clock)
    process(CLK100MHZ)
    begin
        if rising_edge(CLK100MHZ) then
            if reset = '1' then
                slow_clock_counter <= (others => '0');
                slow_clock <= '0';
            else
                slow_clock_counter <= slow_clock_counter + 1;
                if slow_clock_counter = 50000000 then  -- Toggle every 0.5 seconds
                    slow_clock <= not slow_clock;
                    slow_clock_counter <= (others => '0');
                end if;
            end if;
        end if;
    end process;

    -- Display refresh process
    process(CLK100MHZ)
    begin
        if rising_edge(CLK100MHZ) then
            if reset = '1' then
                refresh_counter <= (others => '0');
            else
                refresh_counter <= refresh_counter + 1;
            end if;
        end if;
    end process;

    -- Use refresh counter to select digit
    digit_select <= std_logic_vector(refresh_counter(19 downto 18));

    -- Digit multiplexing process
    process(digit_select, NUMBER)
    begin
        case digit_select is
            when "00" =>
                current_digit <= NUMBER(15 downto 12);
                AN <= "1110";
            when "01" =>
                current_digit <= NUMBER(11 downto 8);
                AN <= "1101";
            when "10" =>
                current_digit <= NUMBER(7 downto 4);
                AN <= "1011";
            when others =>
                current_digit <= NUMBER(3 downto 0);
                AN <= "0111";
        end case;
    end process;

    -- Seven-segment decoder process
    process(current_digit)
    begin
        case current_digit is
            when "0000" => SEG <= "1000000"; -- 0
            when "0001" => SEG <= "1111001"; -- 1
            when "0010" => SEG <= "0100100"; -- 2
            when "0011" => SEG <= "0110000"; -- 3
            when "0100" => SEG <= "0011001"; -- 4
            when "0101" => SEG <= "0010010"; -- 5
            when "0110" => SEG <= "0000010"; -- 6
            when "0111" => SEG <= "1111000"; -- 7
            when "1000" => SEG <= "0000000"; -- 8
            when "1001" => SEG <= "0010000"; -- 9
            when "1010" => SEG <= "0001000"; -- A
            when "1011" => SEG <= "0000011"; -- b
            when "1100" => SEG <= "1000110"; -- C
            when "1101" => SEG <= "0100001"; -- d
            when "1110" => SEG <= "0000110"; -- E
            when "1111" => SEG <= "0001110"; -- F
            when others => SEG <= "1111111"; -- Blank
        end case;
    end process;

end Behavioral;