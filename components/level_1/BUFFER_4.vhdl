-- Include the REG_12 component
library ieee;
use ieee.std_logic_1164.all;

-- Entity declaration
entity BUFFER_4 is
    port (
        input_data : in std_logic_vector(11 downto 0);
        output_data : out std_logic_vector(11 downto 0);
        enable : in std_logic;
        clk : in std_logic
    );
end entity BUFFER_4;

-- Architecture definition
architecture behavioral of BUFFER_4 is
    -- Declare four instances of REG_12 component
    component REG_12 is
        port (
            input_data : in std_logic_vector(11 downto 0);
            output_data : out std_logic_vector(11 downto 0);
            enable : in std_logic;
            clk : in std_logic
        );
    end component REG_12;

    -- Declare signals for connecting the registers
    signal reg1_out, reg2_out, reg3_out, reg4_out : std_logic_vector(11 downto 0);
begin
    -- Instantiate the four registers
    reg1 : REG_12
        port map (
            input_data => input_data,
            output_data => reg1_out,
            enable => enable,
            clk => clk
        );

    reg2 : REG_12
        port map (
            input_data => reg1_out,
            output_data => reg2_out,
            enable => enable,
            clk => clk
        );

    reg3 : REG_12
        port map (
            input_data => reg2_out,
            output_data => reg3_out,
            enable => enable,
            clk => clk
        );

    reg4 : REG_12
        port map (
            input_data => reg3_out,
            output_data => output_data,
            enable => enable,
            clk => clk
        );
end architecture behavioral;