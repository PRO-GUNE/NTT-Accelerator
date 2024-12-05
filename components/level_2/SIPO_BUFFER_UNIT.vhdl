-- Include the REG_12 component
library ieee;
use ieee.std_logic_1164.all;

-- Entity declaration
entity SIPO_BUFFER_UNIT is
    port (
        clk : in std_logic;
        reset : in std_logic;
        enable : in std_logic;
        sel : in std_logic_vector(1 downto 0);
        data_in_0 : in std_logic_vector(11 downto 0);
        data_in_1 : in std_logic_vector(11 downto 0);
        data_in_2 : in std_logic_vector(11 downto 0);
        data_in_3 : in std_logic_vector(11 downto 0);
        data_out : out std_logic_vector(47 downto 0)
    );
end entity SIPO_BUFFER_UNIT;

-- Architecture definition
architecture behavioral of SIPO_BUFFER_UNIT is
    component BUFFER_N is
        generic (
            N : integer := 4 -- Number of REG_12 instances
        );
        port(
            clk : in std_logic;
            reset : in std_logic;
            enable : in std_logic;
            data_in : in std_logic_vector(11 downto 0);
            data_out : out std_logic_vector(47 downto 0)
        );
    end component BUFFER_N;

    component MUX_4 is
        port (
            sel : in std_logic_vector(1 downto 0);
            in0 : in std_logic_vector(47 downto 0);
            in1 : in std_logic_vector(47 downto 0);
            in2 : in std_logic_vector(47 downto 0);
            in3 : in std_logic_vector(47 downto 0);
            c_out : out std_logic_vector(47 downto 0)
        );
    end component MUX_4;
    -- Declare the signals used
    signal buf_out_0, buf_out_1, buf_out_2, buf_out_3 : std_logic_vector(47 downto 0); 

begin
    -- Instantiate 4 buffers
    buf_1 : BUFFER_N
        generic map (
            N => 4
        )
        port map (
            data_in => data_in_0,
            data_out => buf_out_0,
            reset => reset,
            enable => enable,
            clk => clk
        );
    
    buf_2 : BUFFER_N
        generic map (
            N => 5
        )
        port map (
            data_in => data_in_1,
            data_out => buf_out_1,
            reset => reset,
            enable => enable,
            clk => clk
        );
    
    buf_3 : BUFFER_N
        generic map (
            N => 6
        )
        port map (
            data_in => data_in_2,
            data_out => buf_out_2,
            reset => reset,
            enable => enable,
            clk => clk
        );
    
    buf_4 : BUFFER_N
        generic map (
            N => 7
        )
        port map (
            data_in => data_in_3,
            data_out => buf_out_3,
            reset => reset,
            enable => enable,
            clk => clk
        );

    mux_4_out : MUX_4
        port map (
            sel => sel,
            in0 => buf_out_0,
            in1 => buf_out_1,
            in2 => buf_out_2,
            in3 => buf_out_3,
            c_out => data_out
        );

end architecture behavioral;
