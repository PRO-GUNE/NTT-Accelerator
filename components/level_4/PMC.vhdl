library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity PMC is
    port(
        clk : in std_logic;
        reset : in std_logic;
        SW : in STD_LOGIC_VECTOR(15 downto 0);
        AN : out STD_LOGIC_VECTOR(3 downto 0);
        SEG : out STD_LOGIC_VECTOR(6 downto 0);
        LED : out STD_LOGIC_VECTOR(15 downto 0)
    );
end PMC;

architecture Behavioral of PMC is
    component CLK_DIVIDER is
        port(
            clk_in : in std_logic;
            reset : in std_logic;
            clk_out: out std_logic
        );
    end component CLK_DIVIDER;

    component NTT_CORE is
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
    end component NTT_CORE;

    component TWIDDLE_ROM is
        port(
            clk : in std_logic;
            en : in std_logic;
            addr_00 : in std_logic_vector(6 downto 0);
            addr_10 : in std_logic_vector(6 downto 0);
            addr_11 : in std_logic_vector(6 downto 0);
            data_00 : out std_logic_vector(15 downto 0);
            data_10 : out std_logic_vector(15 downto 0);
            data_11 : out std_logic_vector(15 downto 0)
        );
    end component TWIDDLE_ROM;

    component INSTRUCTION_ROM is
        port(
            clk : in std_logic;
            enable : in std_logic;
            write_en : out std_logic;
            data_in_mode : out std_logic;
            mode: out std_logic_vector(7 downto 0);
            sel : out std_logic_vector(1 downto 0);
            addr_00 : out std_logic_vector(6 downto 0);
            addr_10 : out std_logic_vector(6 downto 0);
            addr_11 : out std_logic_vector(6 downto 0);
            addr1 : out std_logic_vector(5 downto 0); 
            addr2 : out std_logic_vector(5 downto 0)
        );
    end component INSTRUCTION_ROM;

    component NTT_RAM is
        port (
            clk       : in  std_logic;
            addr1     : in  std_logic_vector(5 downto 0);
            addr2     : in  std_logic_vector(5 downto 0);
            write_en  : in  std_logic;
            data_in0   : in  std_logic_vector(63 downto 0);
            data_in1 : in std_logic_vector(63 downto 0);
            data_in_mode : in std_logic;
            data_out : out std_logic_vector(63 downto 0)
        );
    end component NTT_RAM;

    component seven_seg_display is
        Port ( 
            CLK100MHZ : in STD_LOGIC;         -- 100MHz clock from Nexys A7
            CPU_RESETN : in STD_LOGIC;         -- Active-low reset button
            SEG : out STD_LOGIC_VECTOR(6 downto 0);  -- Segment signals
            AN : out STD_LOGIC_VECTOR(3 downto 0);   -- Anode signals
            NUMBER : in STD_LOGIC_VECTOR(15 downto 0)    -- 16-bit input number
        );
    end component seven_seg_display;

    signal clk_out : std_logic;
    signal mode : std_logic_vector(7 downto 0);
    signal sel : std_logic_vector(1 downto 0);
    signal data_in : std_logic_vector(63 downto 0);
    signal twiddle_1, twiddle_2, twiddle_3 : std_logic_vector(15 downto 0);
    signal bf_out_sig : std_logic_vector(63 downto 0);

    signal addr_00, addr_10, addr_11: std_logic_vector(6 downto 0);

    signal write_en, data_in_mode : std_logic;
    signal addr1, addr2 : std_logic_vector(5 downto 0);

    signal data_in0 : std_logic_vector(63 downto 0);
    signal enable : std_logic;

begin
    CLK_0: CLK_DIVIDER
        port map(
            clk_in => clk,
            reset => reset,
            clk_out => clk_out
        );

    NTT_CORE_0: NTT_CORE
        port map(
            clk => clk_out,
            mode => mode,
            reset => reset,
            enable => enable,
            sel => sel,
            data_in => data_in,
            twiddle_1 => twiddle_1,
            twiddle_2 => twiddle_2,
            twiddle_3 => twiddle_3,
            BF_out => bf_out_sig
        );

    TW_ROM_0: TWIDDLE_ROM
        port map(
            clk => clk_out,
            en => enable,
            addr_00 => addr_00,
            addr_10 => addr_10,
            addr_11 => addr_11,
            data_00 => twiddle_1,
            data_10 => twiddle_2,
            data_11 => twiddle_3
        );

    INS_ROM_0: INSTRUCTION_ROM
        port map(
            clk => clk_out,
            enable => enable, 
            write_en => write_en,
            mode => mode, 
            sel => sel,
            data_in_mode => data_in_mode,
            addr_00 => addr_00,
            addr_10 => addr_10,
            addr_11 => addr_11,
            addr1 => addr1,
            addr2 => addr2
        );

    RAM_0: NTT_RAM
        port map(
            clk => clk_out,
            addr1 => addr1,
            addr2 => addr2,
            write_en => write_en,
            data_in0 => data_in0,
            data_in1 => bf_out_sig,
            data_in_mode => data_in_mode,
            data_out => data_in
        );

    SEVEN_SEGMENT: seven_seg_display
        port map(
            CLK100MHZ => clk,
            CPU_RESETN => reset, 
            NUMBER => bf_out_sig(15 downto 0),
            AN => AN,
            SEG => SEG
        ); 

    -- BF_out <= bf_out_sig;
    LED <= SW;
    enable <= SW(0);
end Behavioral;