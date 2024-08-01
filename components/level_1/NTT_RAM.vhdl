library ieee;
use ieee.std_logic_1164.all;

-- Entity declaration
entity NTT_RAM is
    generic (
        ADDR_SIZE : integer := 32;
        DATA_SIZE : integer := 48
    );
    port (
        clk       : in  std_logic;
        addr1     : in  std_logic_vector(ADDR_SIZE-1 downto 0);
        addr2     : in  std_logic_vector(ADDR_SIZE-1 downto 0);
        write_en  : in  std_logic;
        data_in0   : in  std_logic_vector(DATA_SIZE-1 downto 0);
        data_in1 : in std_logic_vector(DATA_SIZE-1 downto 0);
        data_in_mode : in std_logic;
        data_out : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end NTT_RAM;

-- Architecture definition
architecture behavioral of NTT_RAM is
    -- Declare two instances of RAM component
    component RAM is
        generic (
            ADDR_SIZE : integer := 32;
            DATA_SIZE : integer := 48
        );
        port (
            clk       : in  std_logic;
            addr1     : in  std_logic_vector(ADDR_SIZE-1 downto 0);
            addr2     : in  std_logic_vector(ADDR_SIZE-1 downto 0);
            write_en  : in  std_logic;
            data_in   : in  std_logic_vector(DATA_SIZE-1 downto 0);
            data_out : out std_logic_vector(DATA_SIZE-1 downto 0)
        );
    end component RAM;

    component MUX_2_RAM is
        generic (
            DATA_SIZE : integer := 48
        );
        port (
            sel : in std_logic;
            in0 : in std_logic_vector(DATA_SIZE-1 downto 0);
            in1 : in std_logic_vector(DATA_SIZE-1 downto 0);
            c_out : out std_logic_vector(DATA_SIZE-1 downto 0)
        );
    end component MUX_2_RAM;

    -- Declare signals for connecting the RAMs
    signal mux_out : std_logic_vector(DATA_SIZE-1 downto 0);

begin

    -- Instantiate the MUX_2_RAM
    mux : MUX_2_RAM
        generic map (
            DATA_SIZE => DATA_SIZE
        )
        port map (
            sel => data_in_mode,
            in0 => data_in0,
            in1 => data_in1,
            c_out => mux_out
        );

    -- Instantiate the two RAMs
    ram : RAM
        generic map (
            ADDR_SIZE => ADDR_SIZE,
            DATA_SIZE => DATA_SIZE
        )
        port map (
            clk => clk,
            addr1 => addr1,
            addr2 => addr2,
            write_en => write_en,
            data_in => mux_out,
            data_out => data_out
        );
        
end behavioral;