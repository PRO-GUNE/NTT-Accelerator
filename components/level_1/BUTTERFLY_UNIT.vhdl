library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BUTTERFLY_UNIT is
    port (
        clk : in std_logic;
        mode : in std_logic_vector(1 downto 0);
        reset : in std_logic;
        enable : in std_logic;
        u_in : in std_logic_vector(11 downto 0);
        v_in : in std_logic_vector(11 downto 0);
        twiddle : in std_logic_vector(11 downto 0);
        u_out : out std_logic_vector(11 downto 0);
        v_out : out std_logic_vector(11 downto 0)
    );
end entity BUTTERFLY_UNIT;

architecture Behavioral of BUTTERFLY_UNIT is

    -- 2 way multiplexer
    component MUX_2
        port (
            sel : in std_logic;
            in0 : in std_logic_vector(11 downto 0);
            in1 : in std_logic_vector(11 downto 0);
            c_out : out std_logic_vector(11 downto 0)
        );
    end component MUX_2;

    -- 3 way multiplexer
    component MUX_3
        port (
            sel : in std_logic_vector(1 downto 0);
            in0 : in std_logic_vector(11 downto 0);
            in1 : in std_logic_vector(11 downto 0);
            in2 : in std_logic_vector(11 downto 0);
            c_out : out std_logic_vector(11 downto 0)
        );
    end component MUX_3;

    -- register 12 bits
    component REG_12
        port (
            clk : in std_logic;
            reset : in std_logic;
            enable : in std_logic;
            data_in : in std_logic_vector(11 downto 0);
            data_out : out std_logic_vector(11 downto 0)
        );
    end component REG_12;

    -- modular addition
    component MOD_ADD
        port (
            clk    : in  std_logic;
            reset  : in  std_logic;
            enable : in  std_logic;
            a      : in  std_logic_vector(11 downto 0);
            b      : in  std_logic_vector(11 downto 0);
            sum    : out std_logic_vector(11 downto 0)
        );
    end component MOD_ADD;

    -- modular addition
    component MOD_SUB
        port (
            clk    : in  std_logic;
            reset  : in  std_logic;
            enable : in  std_logic;
            a      : in  std_logic_vector(11 downto 0);
            b      : in  std_logic_vector(11 downto 0);
            diff   : out std_logic_vector(11 downto 0)
        );
    end component MOD_SUB;

    -- reduction modulo k2-RED
    component MOD_K2_RED
        port (
            clk     : in std_logic;  
            reset   : in std_logic;  
            c_in    : in std_logic_vector(23 downto 0);
            c_out   : out std_logic_vector(11 downto 0)
        );
    end component MOD_K2_RED;

    -- multiplication component
    component MUL
        port (
            clk     : in  std_logic;
            enable  : in  std_logic;                     
            a       : in  std_logic_vector(11 downto 0);
            b       : in  std_logic_vector(11 downto 0);
            result  : out std_logic_vector(23 downto 0)
        );
    end component MUL;

    signal reg_u1_out, reg_u2_out, reg_u3_out, reg_u4_out : std_logic_vector(11 downto 0);
    signal reg_v1_out, reg_v2_out, reg_v3_out, reg_v4_out : std_logic_vector(11 downto 0);
    signal reg_twiddle_out : std_logic_vector(11 downto 0);
    signal mux_u1_out, mux_v1_out, mux_twiddle_out, mux_vu1_out, mux_vsub_out : std_logic_vector(11 downto 0);
    signal mod_k2_red_out, mod_sub_out, mod_add_out : std_logic_vector(11 downto 0);
    signal mod_mul_out : std_logic_vector(23 downto 0);

begin
    -- register u1
    reg_u1: REG_12 port map (
            clk => clk,
            reset => reset,
            enable => enable,
            data_in => u_in,
            data_out => reg_u1_out
        );

    -- register u2
    reg_u2: REG_12 port map (
            clk => clk,
            reset => reset,
            enable => enable,
            data_in => reg_u1_out,
            data_out => reg_u2_out
        );

    -- register u3
    reg_u3: REG_12 port map (
            clk => clk,
            reset => reset,
            enable => enable,
            data_in => reg_u2_out,
            data_out => reg_u3_out
        );

    -- register v1
    reg_v1: REG_12 port map (
            clk => clk,
            reset => reset,
            enable => enable,
            data_in => v_in,
            data_out => reg_v1_out
        );

    -- register v2
    reg_v2: REG_12 port map (
            clk => clk,
            reset => reset,
            enable => enable,
            data_in => reg_v1_out,
            data_out => reg_v2_out
        );

    -- register v3
    reg_v3: REG_12 port map (
            clk => clk,
            reset => reset,
            enable => enable,
            data_in => reg_v2_out,
            data_out => reg_v3_out
        );

    -- register u4
    reg_u4: REG_12 port map (
            clk => clk,
            reset => reset,
            enable => enable,
            data_in => reg_u3_out,
            data_out => reg_u4_out
        );

    -- register v4
    reg_v4: REG_12 port map (
            clk => clk,
            reset => reset,
            enable => enable,
            data_in => reg_v3_out,
            data_out => reg_v4_out
        );

    -- twiddle factor register
    reg_twiddle: REG_12 port map (
            clk => clk,
            reset => reset,
            enable => enable,
            data_in => twiddle,
            data_out => reg_twiddle_out
        );

    -- mux twiddle
    mux_2_twiddle: MUX_2 port map (
            sel => mode(0),
            in0 => twiddle,
            in1 => reg_twiddle_out,
            c_out => mux_twiddle_out
        );

    -- mux u1
    mux_2_u1: MUX_2 port map (
            sel => mode(0),
            in0 => reg_u3_out,
            in1 => u_in,
            c_out => mux_u1_out
        );

    -- mux v1
    mux_2_v1: MUX_2 port map (
            sel => mode(0),
            in0 => mux_vu1_out,
            in1 => v_in,
            c_out => mux_v1_out
        );

    -- mux vu1
    mux_2_vu1: MUX_2 port map (
            sel => mode(0),
            in0 => mod_k2_red_out,
            in1 => reg_v3_out,
            c_out => mux_vu1_out
        );

    mux_2_vsub: MUX_2 port map (
            sel => mode(0),
            in0 => v_in,
            in1 => mod_sub_out,
            c_out => mux_vsub_out
        );

    -- mod sub
    mod_sub_unit: MOD_SUB port map (
            clk => clk,
            reset => reset,
            enable => enable,
            a => mux_u1_out,
            b => mux_v1_out,
            diff => mod_sub_out
        );

    -- multiplication
    mul_unit: MUL port map (
            clk => clk,
            enable => enable,
            a => mux_vsub_out,
            b => mux_twiddle_out,
            result => mod_mul_out
        );

    -- reduction modulo k2-RED
    mod_k2_red_unit: MOD_K2_RED port map (
            clk => clk,
            reset => reset,
            c_in => mod_mul_out,
            c_out => mod_k2_red_out
        );

    -- mod add
    mod_add_unit: MOD_ADD port map (
            clk => clk,
            reset => reset,
            enable => enable,
            a => reg_u3_out,
            b => mux_vu1_out,
            sum => mod_add_out
        );

    -- mux u out
    mux_3_u_out: MUX_3 port map (
            sel => mode,
            in0 => mod_add_out,
            in1 => mod_add_out,
            in2 => reg_u4_out,
            c_out => u_out
        );

    -- mux v out
    mux_3_v_out: MUX_3 port map (
            sel => mode,
            in0 => mod_sub_out,
            in1 => mod_k2_red_out,
            in2 => reg_v4_out,
            c_out => v_out
        );
end architecture Behavioral;