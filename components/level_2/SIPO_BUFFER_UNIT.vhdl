-- Include the REG_12 component
library ieee;
use ieee.std_logic_1164.all;

-- Entity declaration
entity SIPO_BUFFER_UNIT is
    port (
        clk : in std_logic;
        reset : in std_logic;
        enable : in std_logic;
        data_in_0 : in std_logic_vector(11 downto 0);
        data_in_1 : in std_logic_vector(11 downto 0);
        data_in_2 : in std_logic_vector(11 downto 0);
        data_in_3 : in std_logic_vector(11 downto 0);
        data_out : out std_logic_vector(47 downto 0)
    );
end entity SIPO_BUFFER_UNIT;

-- Architecture definition
architecture behavioral of SIPO_BUFFER_UNIT is
    component BUFFER_4 is
        port(
            clk : in std_logic;
            reset : in std_logic;
            enable : in std_logic;
            data_in : in std_logic_vector(11 downto 0);
            data_out : out std_logic_vector(11 downto 0)
        );
    end component BUFFER_4;

    -- Declare the signals used
    signal buf_out_0, buf_out_1, buf_out_2, buf_out_3 : std_logic_vector(11 downto 0); 

begin
    -- Instantiate 4 buffers
    buf_1 : BUFFER_4
        port map (
            data_in => data_in_0,
            data_out => buf_out_0,
            reset => reset,
            enable => enable,
            clk => clk
        );
    
    buf_2 : BUFFER_4
        port map (
            data_in => data_in_1,
            data_out => buf_out_1,
            reset => reset,
            enable => enable,
            clk => clk
        );
    
    buf_3 : BUFFER_4
        port map (
            data_in => data_in_2,
            data_out => buf_out_2,
            reset => reset,
            enable => enable,
            clk => clk
        );
    
    buf_4 : BUFFER_4
        port map (
            data_in => data_in_3,
            data_out => buf_out_3,
            reset => reset,
            enable => enable,
            clk => clk
        );
    
    -- Output the data
    data_out(11 downto 0) <= buf_out_0;
    data_out(23 downto 12) <= buf_out_1;
    data_out(35 downto 24) <= buf_out_2;
    data_out(47 downto 36) <= buf_out_3;

end architecture behavioral;
