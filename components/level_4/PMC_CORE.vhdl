library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PMC_CORE is
    generic (
        DATA_SIZE : integer := 48
    )
    port(
        clk : in std_logic;
        reset : in std_logic;
        proc_start : in std_logic;
        proc_done : out std_logic;
        data_in : in std_logic_vector(DATA_SIZE-1 downto 0);
        data_out : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end PMC_CORE;

architecture Behavioral of PMC_CORE is
end Behavioral;