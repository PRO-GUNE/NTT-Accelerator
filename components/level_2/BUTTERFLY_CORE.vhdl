library ieee;
use ieee.std_logic_1164.all;

entity BUTTERFLY_CORE is
  port (
    clk : in std_logic;
    mode : in std_logic;
    u1_in : in std_logic_vector(11 downto 0);
    u2_in : in std_logic_vector(11 downto 0);
    v1_in : in std_logic_vector(11 downto 0);
    v2_in : in std_logic_vector(11 downto 0);
    twiddle_1 : in std_logic_vector(11 downto 0);
    twiddle_2 : in std_logic_vector(11 downto 0);
    twiddle_3 : in std_logic_vector(11 downto 0);
    twiddle_4 : in std_logic_vector(11 downto 0);
    u1_out : out std_logic_vector(11 downto 0);
    u2_out : out std_logic_vector(11 downto 0);
    v1_out : out std_logic_vector(11 downto 0);
    v2_out : out std_logic_vector(11 downto 0)
  ) ;
end BUTTERFLY_CORE;

architecture Behavioral of BUTTERFLY_CORE is
    component BUTTERFLY_UNIT is
        port (
            clk : in std_logic;
            mode : in std_logic; 
            u_in : in std_logic_vector(11 downto 0);
            v_in : in std_logic_vector(11 downto 0);
            twiddle : in std_logic_vector(11 downto 0);
            u_out : out std_logic_vector(11 downto 0);
            v_out : out std_logic_vector(11 downto 0)
        );
    end component BUTTERFLY_UNIT;    

    signal u1_mid, u2_mid : std_logic_vector(11 downto 0);
    signal v1_mid, v2_mid : std_logic_vector(11 downto 0);

    begin
        BUT_0: BUTTERFLY_UNIT port map (
            clk => clk,
            mode => mode,
            u_in => u1_in,
            v_in => v1_in,
            twiddle => twiddle(11 downto 0),
            u_out => u1_mid,
            v_out => u2_mid
        );

        BUT_1: BUTTERFLY_UNIT port map (
            clk => clk,
            mode => mode,
            u_in => u2_in,
            v_in => v2_in,
            twiddle => twiddle(23 downto 12),
            u_out => v1_mid,
            v_out => v2_mid
        );

        BUT_2: BUTTERFLY_UNIT port map (
            clk => clk,
            mode => mode,
            u_in => u1_mid,
            v_in => v1_mid,
            twiddle => twiddle(35 downto 24),
            u_out => u1_out,
            v_out => u2_out
        );

        BUT_3: BUTTERFLY_UNIT port map (
            clk => clk,
            mode => mode,
            u_in => u2_mid,
            v_in => v2_mid,
            twiddle => twiddle(47 downto 36),
            u_out => v1_out,
            v_out => v2_out
        );


end architecture Behavioral;