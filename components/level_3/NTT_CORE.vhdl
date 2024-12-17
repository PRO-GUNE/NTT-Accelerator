library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity NTT_CORE is
    port(
        clk : in std_logic;
        mode : in std_logic_vector(7 downto 0);
        reset : in std_logic;
        enable : in std_logic;
        sel : in std_logic_vector(1 downto 0);
        data_in : in std_logic_vector(63 downto 0);
        twiddle_1 : in std_logic_vector(15 downto 0);
        twiddle_2 : in std_logic_vector(15 downto 0);
        twiddle_3 : in std_logic_vector(15 downto 0);
        BF_out : out std_logic_vector(63 downto 0)
    );
end NTT_CORE;

-- Architecture definition
architecture Behavioral of NTT_CORE is
    component CLK_DIVIDER is
        port(
            clk_in : in std_logic;
            reset : in std_logic;
            clk_out: out std_logic
        );
    end component CLK_DIVIDER;

    component BUTTERFLY_CORE is
        port (
            clk : in std_logic;
            mode : in std_logic_vector(7 downto 0);
            reset : in std_logic;
            enable : in std_logic;
            u1_in : in std_logic_vector(15 downto 0);
            u2_in : in std_logic_vector(15 downto 0);
            v1_in : in std_logic_vector(15 downto 0);
            v2_in : in std_logic_vector(15 downto 0);
            twiddle_1 : in std_logic_vector(15 downto 0);
            twiddle_2 : in std_logic_vector(15 downto 0);
            twiddle_3 : in std_logic_vector(15 downto 0);
            u1_out : out std_logic_vector(15 downto 0);
            u2_out : out std_logic_vector(15 downto 0);
            v1_out : out std_logic_vector(15 downto 0);
            v2_out : out std_logic_vector(15 downto 0)
        );
    end component BUTTERFLY_CORE;

    component SIPO_BUFFER_UNIT is
        port (
            clk : in std_logic;
            reset : in std_logic;
            enable : in std_logic;
            sel : in std_logic_vector(1 downto 0);
            data_in_0 : in std_logic_vector(15 downto 0);
            data_in_1 : in std_logic_vector(15 downto 0);
            data_in_2 : in std_logic_vector(15 downto 0);
            data_in_3 : in std_logic_vector(15 downto 0);
            data_out : out std_logic_vector(63 downto 0)
        );
    end component SIPO_BUFFER_UNIT;

    signal u1_out, u2_out, v1_out, v2_out : std_logic_vector(15 downto 0);
    signal clk_out : std_logic;

begin
    -- Instantiate the BUTTERFLY_CORE
    CLK_0: CLK_DIVIDER
        port map(
            clk_in => clk,
            reset => reset,
            clk_out => clk_out
        );
     
    BUT_0: BUTTERFLY_CORE
        port map (
            clk => clk_out,
            mode => mode,
            reset => reset,
            enable => enable,
            u1_in => data_in(15 downto 0),
            u2_in => data_in(31 downto 16),
            v1_in => data_in(47 downto 32),
            v2_in => data_in(63 downto 48),
            twiddle_1 => twiddle_1,
            twiddle_2 => twiddle_2,
            twiddle_3 => twiddle_3,
            u1_out => u1_out,
            u2_out => u2_out,
            v1_out => v1_out,
            v2_out => v2_out
        );

    -- Instantiate the SIPO_BUFFER_UNIT
    PISO_BUF: SIPO_BUFFER_UNIT
        port map (
            clk => clk_out,
            reset => reset,
            enable => enable,
            sel => sel,
            data_in_0 => u1_out,
            data_in_1 => v1_out,
            data_in_2 => u2_out,
            data_in_3 => v2_out,
            data_out => BF_out
        );
    
end Behavioral;