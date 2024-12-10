library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Entity declaration
entity BUFFER_N is
    generic (
        N : integer := 4 -- Number of REG_12 instances
    );
    port (
        clk : in std_logic;
        reset : in std_logic;
        enable : in std_logic;
        data_in : in std_logic_vector(11 downto 0);
        data_out : out std_logic_vector(47 downto 0)
    );
end entity BUFFER_N;

-- Architecture definition
architecture behavioral of BUFFER_N is
    -- Declare the REG_12 component
    component REG_12 is
        port (
            clk : in std_logic;
            reset : in std_logic;
            enable : in std_logic;
            data_in : in std_logic_vector(11 downto 0);
            data_out : out std_logic_vector(11 downto 0)
        );
    end component REG_12;

    -- Declare an array of signals to connect the outputs of each REG_12 instance
    type reg_array is array (0 to N-1) of std_logic_vector(11 downto 0);
    signal regs : reg_array;
    
begin
    -- Connect input to the first register and output to the last
    regs(0) <= data_in;

    -- Output the data
    data_out(11 downto 0) <= regs(N-1);
    data_out(23 downto 12) <= regs(N-2);
    data_out(35 downto 24) <= regs(N-3);
    data_out(47 downto 36) <= regs(N-4); 

    -- Generate loop to instantiate N REG_12 components
    gen_regs : for i in 1 to N-1 generate
        reg_inst : REG_12
            port map (
                clk => clk,
                reset => reset,
                enable => enable,
                data_in => regs(i-1),
                data_out => regs(i)
            );
    end generate gen_regs;

end architecture behavioral;
