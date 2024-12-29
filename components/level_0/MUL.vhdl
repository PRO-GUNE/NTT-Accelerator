library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUL is
    port (
        clk     : in  std_logic;
        enable  : in  std_logic;                     
        a       : in  std_logic_vector(11 downto 0);
        b       : in  std_logic_vector(11 downto 0);
        result  : out std_logic_vector(23 downto 0)
    );
end entity MUL;

architecture rtl of MUL is
    -- Attribute to ensure DSP inference
    attribute use_dsp : string;
    attribute use_dsp of rtl : architecture is "yes";
    
    signal P_out : std_logic_vector(25 downto 0);
    signal A_in, B_in : std_logic_vector(12 downto 0);

    COMPONENT dsp_macro_0
       PORT (
            CLK : IN STD_LOGIC;
            A : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
            P : OUT STD_LOGIC_VECTOR(25 DOWNTO 0) 
        );
    END COMPONENT;

begin
    dsp_mul_unit : dsp_macro_0
    port map(
        CLK => clk,
        A => A_in,
        B => B_in,
        P => P_out
    );

    result <= P_out(23 downto 0);
    A_in <= '0' & a;
    B_in <= '0' & b;
    
end architecture rtl;