-- Include the REG_12 component
library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Entity declaration
entity BUFFER_4 is
    port (
        clk : in std_logic;
        reset : in std_logic;
        enable : in std_logic;
        data_in : in std_logic_vector(11 downto 0);
        data_out : out std_logic_vector(11 downto 0)
    );
end entity BUFFER_4;

-- Architecture definition
architecture behavioral of BUFFER_4 is
    -- Declare four instances of REG_12 component
    component REG_12 is
        port (
            clk : in std_logic;
            reset : in std_logic;
            enable : in std_logic;
            data_in : in std_logic_vector(11 downto 0);
            data_out : out std_logic_vector(11 downto 0)
        );
    end component REG_12;

    -- Declare signals for connecting the registers
    signal reg1_out, reg2_out, reg3_out, reg4_out : std_logic_vector(11 downto 0);
begin
    -- Instantiate the four registers
    reg1 : REG_12
        port map (
            data_in => data_in,
            data_out => reg1_out,
            reset => reset,
            enable => enable,
            clk => clk
        );

    reg2 : REG_12
        port map (
            data_in => reg1_out,
            data_out => reg2_out,
            reset => reset,
            enable => enable,
            clk => clk
        );

    reg3 : REG_12
        port map (
            data_in => reg2_out,
            data_out => reg3_out,
            reset => reset,
            enable => enable,
            clk => clk
        );

    reg4 : REG_12
        port map (
            data_in => reg3_out,
            data_out => data_out,
            reset => reset,
            enable => enable,
            clk => clk
        );
end architecture behavioral;