library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MOD_SUB is
    port (
        a : in std_logic_vector(11 downto 0);
        b : in std_logic_vector(11 downto 0);
        diff : out std_logic_vector(11 downto 0)
    );
end entity MOD_SUB;

architecture behavioral of MOD_SUB is
    -- Constants
    constant MODULUS : unsigned(11 downto 0) := to_unsigned(3329, 12);
        
    -- Attribute to guide DSP inference
    attribute use_dsp : string;
    attribute use_dsp of Behavioral : architecture is "yes";

    -- DSP pattern: (A * 1) + B for initial addition
    signal a_extended : unsigned(17 downto 0);  -- DSP B input width
    signal b_extended : unsigned(47 downto 0);  -- DSP C input width
    signal mult_one   : unsigned(17 downto 0);  -- Constant 1
    signal temp_diff   : unsigned(47 downto 0);  -- DSP output width

    -- DSP pattern: (Result * 1) - Modulus for correction
    signal mod_extended : unsigned(47 downto 0);
    signal corrected_diff : unsigned(47 downto 0);

begin
    -- Extend inputs for DSP alignment
    a_extended <= resize(unsigned(a), 18);
    b_extended <= resize(unsigned(b), 48);
    mult_one <= "000000" & x"001";
    mod_extended <= resize(MODULUS, 48);

    -- First DSP operation: A + B
    -- Using multiplication by 1 to force DSP inference
    temp_diff <= (a_extended * mult_one) - b_extended;

    -- Second DSP operation: Conditional subtraction of modulus
    -- Also using multiplication by 1 pattern
    corrected_diff <= temp_diff + mod_extended when a < b else
                    temp_diff;

    -- Output assignment
    diff <= std_logic_vector(corrected_diff(11 downto 0));
end architecture behavioral;