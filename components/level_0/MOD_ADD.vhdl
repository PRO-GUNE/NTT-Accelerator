library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MOD_ADD is
    port (
        clk    : in  std_logic;
        reset  : in  std_logic;
        enable : in  std_logic;
        a      : in  std_logic_vector(11 downto 0);
        b      : in  std_logic_vector(11 downto 0);
        sum    : out std_logic_vector(11 downto 0)
    );
end entity MOD_ADD;

architecture behavioral of MOD_ADD is
    -- Constants
    constant MODULUS : unsigned(11 downto 0) := to_unsigned(3329, 12);
    
    -- Attribute to guide DSP inference
    attribute use_dsp : string;
    attribute use_dsp of behavioral : architecture is "yes";
    
    -- Pipeline registers for inputs
    signal a_reg1, a_reg2 : std_logic_vector(11 downto 0);
    signal b_reg1, b_reg2 : std_logic_vector(11 downto 0);
    
    -- Extended signal registers
    signal a_extended, a_extended_reg : unsigned(17 downto 0);
    signal b_extended, b_extended_reg : unsigned(47 downto 0);
    signal mult_one : unsigned(17 downto 0);
    signal mod_extended : unsigned(47 downto 0);
    
    -- DSP output registers
    signal temp_sum_reg : unsigned(47 downto 0);
    signal corrected_sum_reg : unsigned(47 downto 0);
    
    -- Comparison register
    signal comp_reg : std_logic;

begin
    -- Pipeline registers process
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                -- Reset all registers
                a_reg1 <= (others => '0');
                a_reg2 <= (others => '0');
                b_reg1 <= (others => '0');
                b_reg2 <= (others => '0');
                a_extended_reg <= (others => '0');
                b_extended_reg <= (others => '0');
                temp_sum_reg <= (others => '0');
                corrected_sum_reg <= (others => '0');
                comp_reg <= '0';
            elsif enable = '1' then
                -- Stage 1: Input registers
                a_reg1 <= a;
                b_reg1 <= b;
                
                -- Stage 2: Extended registers
                a_reg2 <= a_reg1;
                b_reg2 <= b_reg1;
                a_extended_reg <= resize(unsigned(a_reg1), 18);
                b_extended_reg <= resize(unsigned(b_reg1), 48);
                
                -- Stage 3: DSP operation registers
                temp_sum_reg <= (a_extended_reg * mult_one) + b_extended_reg;
                
                -- Stage 4: Final result register with comparison
                if temp_sum_reg >= mod_extended then
                    corrected_sum_reg <= temp_sum_reg - mod_extended;
                else
                    corrected_sum_reg <= temp_sum_reg;
                end if;
            end if;
        end if;
    end process;

    -- Constants and static signals
    mult_one <= "000000" & x"001";
    mod_extended <= resize(MODULUS, 48);

    -- Output assignment
    sum <= std_logic_vector(corrected_sum_reg(11 downto 0));

end architecture behavioral;