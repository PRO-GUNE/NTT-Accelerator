library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity test_NTT_CT is
end test_NTT_CT;

architecture testbench of test_NTT_CT is
    -- Constants
    constant ADDR_SIZE : integer := 5;
    constant DATA_SIZE : integer := 48;
    
    -- Clock signal
    signal clk       : std_logic := '0';

    -- NTT Core Signals
    signal mode : std_logic_vector(7 downto 0) := (others => '0');
    signal reset : std_logic := '0';
    signal enable : std_logic := '0';
    signal sel : std_logic_vector(1 downto 0) := (others => '0');
    signal BF_out : std_logic_vector(DATA_SIZE-1 downto 0);

    -- Twiddle ROM Signals
    signal addr_00, addr_10, addr_11 : std_logic_vector(6 downto 0) := (others => '0');
    signal twiddle_00, twiddle_10, twiddle_11: std_logic_vector(11 downto 0);

    -- RAM Signals
    signal addr1     : std_logic_vector(ADDR_SIZE downto 0) := (others => '0');
    signal addr2     : std_logic_vector(ADDR_SIZE downto 0) := (others => '0');
    signal write_en  : std_logic := '0';
    signal data_in0  : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');
    signal data_in_mode : std_logic := '0';
    signal data_out  : std_logic_vector(DATA_SIZE-1 downto 0);

    -- Output monitoring signals
    signal val1, val2, val3, val4 : std_logic_vector(11 downto 0) := (others => '0');
    signal bval1, bval2, bval3, bval4 : std_logic_vector(11 downto 0) := (others => '0');

    -- Twiddle ROM Component
    component TWIDDLE_ROM
        port(
            clk : in std_logic;
            en : in std_logic;
            addr_00 : in std_logic_vector(6 downto 0);
            addr_10 : in std_logic_vector(6 downto 0);
            addr_11 : in std_logic_vector(6 downto 0);
            data_00 : out std_logic_vector(11 downto 0);
            data_10 : out std_logic_vector(11 downto 0);
            data_11 : out std_logic_vector(11 downto 0)
        );
    end component TWIDDLE_ROM;

    -- NTT RAM Component
    component NTT_RAM is
        generic (
            ADDR_SIZE : integer := 5;
            DATA_SIZE : integer := 48
        );
        port (
            clk       : in  std_logic;
            addr1     : in  std_logic_vector(ADDR_SIZE downto 0);
            addr2     : in  std_logic_vector(ADDR_SIZE downto 0);
            write_en  : in  std_logic;
            data_in0  : in  std_logic_vector(DATA_SIZE-1 downto 0);
            data_in1  : in  std_logic_vector(DATA_SIZE-1 downto 0);
            data_in_mode : in std_logic;
            data_out  : out std_logic_vector(DATA_SIZE-1 downto 0)
        );
    end component NTT_RAM;

    component NTT_CORE is
        port(
            clk : in std_logic;
            mode : in std_logic_vector(7 downto 0);
            reset : in std_logic;
            enable : in std_logic;
            sel : in std_logic_vector(1 downto 0);
            data_in : in std_logic_vector(47 downto 0);
            twiddle_1 : in std_logic_vector(11 downto 0);
            twiddle_2 : in std_logic_vector(11 downto 0);
            twiddle_3 : in std_logic_vector(11 downto 0);
            BF_out : out std_logic_vector(47 downto 0)
        );
    end component NTT_CORE;

begin
    -- Instantiate the ROM
    ROM: TWIDDLE_ROM
        port map (
            clk => clk,
            en => enable,
            addr_00 => addr_00,
            addr_10 => addr_10,
            addr_11 => addr_11,
            data_00 => twiddle_00,
            data_10 => twiddle_10,
            data_11 => twiddle_11
        );


    -- Instantiate the RAM
    RAM : NTT_RAM
        generic map (
            ADDR_SIZE => ADDR_SIZE,
            DATA_SIZE => DATA_SIZE
        )
        port map (
            clk => clk,
            addr1 => addr1,
            addr2 => addr2,
            write_en => write_en,
            data_in0 => data_in0,
            data_in1 => BF_out,
            data_in_mode => data_in_mode,
            data_out => data_out
        );

    -- Instantiate the NTT Core
    CORE: NTT_CORE
        port map (
            clk => clk,
            mode => mode,
            reset => reset,
            enable => enable,
            sel => sel,
            data_in => data_out,
            twiddle_1 => twiddle_00,
            twiddle_2 => twiddle_10,
            twiddle_3 => twiddle_11,
            BF_out => BF_out
        );

    -- Clock generation
    clk_process : process
    begin
        clk <= not clk;
        wait for 5 ns;
    end process;
    
    -- Write to RAM with delay
    write_process : process
        variable n : integer := 128;
    begin
        -- reset
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        wait for 10 ns;

        -- NTT Core disabled
        enable <= '0';
        -- Load data to the RAM
        write_en <= '1';
        data_in_mode <= '0';

        wait for 20 ns;
        n := n/2;


        for i in 0 to 31 loop
            addr1 <= std_logic_vector(to_unsigned(i, 6));
            data_in0(11 downto 0) <= std_logic_vector(to_unsigned(2*i, 12));
            data_in0(23 downto 12) <= std_logic_vector(to_unsigned(2*(32+i), 12));
            data_in0(35 downto 24) <= std_logic_vector(to_unsigned(2*(n+i), 12));
            data_in0(47 downto 36) <= std_logic_vector(to_unsigned(2*(32+n+i), 12));
            wait for 20 ns;
        end loop;

        -- Send data to the NTT Core
        enable <= '1';
        write_en <= '0';
        addr1 <= std_logic_vector(to_unsigned(0, 6));
        wait for 40 ns;

        data_in_mode <= '1';
        write_en <= '1';
        
        wait;
        -- data_in_mode <= '1';
        -- write_en <= '1';
        
        -- -- Round 1 (Stage 1 and Stage 2)
        -- for i in 0 to 7 loop
        --     -- Reading from memory
        --     addr1 <= std_logic_vector(to_unsigned(i, 6)); -- 0
        --     wait for 10 ns;
        --     addr1 <= std_logic_vector(to_unsigned(i+1*8, 6)); -- 8
        --     wait for 10 ns;
        --     addr1 <= std_logic_vector(to_unsigned(i+2*8, 6)); -- 16
        --     wait for 10 ns;
        --     addr1 <= std_logic_vector(to_unsigned(i+3*8, 6)); -- 24
        --     wait for 10 ns;
        -- end loop;

        -- -- wait for 6 clk cycles
        -- wait for 60 ns;

        -- -- Round 2 (Stage 3 and Stage 4)
        -- for j in 0 to 3 loop
        --     for i in 0 to 1 loop
        --         -- Reading from memory
        --         addr1 <= std_logic_vector(to_unsigned(j*8+i, 6)); -- 0
        --         wait for 10 ns;
        --         addr1 <= std_logic_vector(to_unsigned(j*8+i+1*2, 6)); -- 2
        --         wait for 10 ns;
        --         addr1 <= std_logic_vector(to_unsigned(j*8+i+2*2, 6)); -- 4
        --         wait for 10 ns;
        --         addr1 <= std_logic_vector(to_unsigned(j*8+i+3*2, 6)); -- 6
        --         wait for 10 ns;
        --     end loop;
        -- end loop;

        -- -- wait for 6 clk cycles
        -- wait for 60 ns;

        -- -- Round 3 (Stage 5 and Stage 6)
        -- for i in 0 to 7 loop
        --     addr1 <= std_logic_vector(to_unsigned(i*4, 6)); -- 0
        --     wait for 10 ns;
        --     addr1 <= std_logic_vector(to_unsigned(i*4+1*1, 6)); -- 1
        --     wait for 10 ns;
        --     addr1 <= std_logic_vector(to_unsigned(i*4+2*1, 6)); -- 2
        --     wait for 10 ns;
        --     addr1 <= std_logic_vector(to_unsigned(i*4+3*1, 6)); -- 3
        --     wait for 10 ns;
        -- end loop;

        -- -- wait for 6 clk cycles
        -- wait for 60 ns;

        -- -- Round 4 (Stage 7)
        -- for i in 0 to 31 loop
        --     -- Reading from memory
        --     addr1 <= std_logic_vector(to_unsigned(i, 6));
        --     wait for 10 ns;
        -- end loop;

        -- -- wait for 6 clk cycles
        -- wait for 60 ns;

        -- -- Disable NTT Core
        -- enable <= '0';
        -- write_en <= '0';
        
        -- wait;
    end process;

    -- Main process
    main_process : process
        variable addr : integer := 1;
    begin
        -- wait for 680 ns;

        -- -- test case 1
        -- addr_00 <= std_logic_vector(to_unsigned(addr, 7));
        -- addr_10 <= std_logic_vector(to_unsigned(addr+1, 7));
        -- addr_11 <= std_logic_vector(to_unsigned(addr+2, 7));
        -- addr2 <= std_logic_vector(to_unsigned(0, 6));
        -- wait for 140 ns;

        wait;

        -- -- Round 1 (Stage 1 and Stage 2)
        -- for i in 0 to 7 loop
        --     -- twiddle factor addresses
        --     addr_00 <= std_logic_vector(to_unsigned(addr, 7));
        --     addr_10 <= std_logic_vector(to_unsigned(addr+1, 7));
        --     addr_11 <= std_logic_vector(to_unsigned(addr+2, 7));

        --     -- Reading from memory
        --     addr2 <= std_logic_vector(to_unsigned(i, 6)); -- 0
        --     wait for 10 ns;
        --     addr2 <= std_logic_vector(to_unsigned(i+1*8, 6)); -- 8
        --     wait for 10 ns;
        --     addr2 <= std_logic_vector(to_unsigned(i+2*8, 6)); -- 16
        --     wait for 10 ns;
        --     addr2 <= std_logic_vector(to_unsigned(i+3*8, 6)); -- 24
        --     wait for 10 ns;
        -- end loop;

        -- -- wait 6 clk cycles 
        -- wait for 60 ns;
        -- addr := 4;

        -- -- Round 2 (Stage 3 and Stage 4)
        -- for j in 0 to 3 loop
        --     -- twiddle factor addresses
        --     addr_00 <= std_logic_vector(to_unsigned(addr, 7));
        --     addr_10 <= std_logic_vector(to_unsigned(addr+1, 7));
        --     addr_11 <= std_logic_vector(to_unsigned(addr+2, 7));

        --     for i in 0 to 1 loop
        --         -- Reading from memory
        --         addr2 <= std_logic_vector(to_unsigned(j*8+i, 6)); -- 0
        --         wait for 10 ns;
        --         addr2 <= std_logic_vector(to_unsigned(j*8+i+1*2, 6)); -- 2
        --         wait for 10 ns;
        --         addr2 <= std_logic_vector(to_unsigned(j*8+i+2*2, 6)); -- 4
        --         wait for 10 ns;
        --         addr2 <= std_logic_vector(to_unsigned(j*8+i+3*2, 6)); -- 6
        --         wait for 10 ns;
        --     end loop;

        --     addr := addr + 3;
        -- end loop;
        
        -- -- wait 6 clk cycles 
        -- wait for 60 ns;
        -- addr := 16;


        -- -- Round 3 (Stage 5 and Stage 6)
        -- for i in 0 to 7 loop
        --     -- twiddle factor addresses
        --     addr_00 <= std_logic_vector(to_unsigned(addr, 7));
        --     addr_10 <= std_logic_vector(to_unsigned(addr+1, 7));
        --     addr_11 <= std_logic_vector(to_unsigned(addr+2, 7));

        --     -- Reading from memory
        --     addr2 <= std_logic_vector(to_unsigned(i*4, 6)); -- 0
        --     wait for 10 ns;
        --     addr2 <= std_logic_vector(to_unsigned(i*4+1*1, 6)); -- 1
        --     wait for 10 ns;
        --     addr2 <= std_logic_vector(to_unsigned(i*4+2*1, 6)); -- 2
        --     wait for 10 ns;
        --     addr2 <= std_logic_vector(to_unsigned(i*4+3*1, 6)); -- 3
        --     wait for 10 ns;

        --     addr := addr + 3;
        -- end loop;

        -- -- wait 6 clk cycles 
        -- wait for 60 ns;
        -- addr := 32;

        -- -- Round 4 (Stage 7)
        -- mode <= "00001010"; -- Odd stage

        -- for i in 0 to 31 loop
        --     -- twiddle factor addresses
        --     addr_00 <= std_logic_vector(to_unsigned(0, 7));
        --     addr_10 <= std_logic_vector(to_unsigned(addr+1, 7));
        --     addr_11 <= std_logic_vector(to_unsigned(addr+2, 7));

        --     -- Reading from memory
        --     addr2 <= std_logic_vector(to_unsigned(i, 6));
        --     wait for 10 ns;

        --     addr := addr + 2;
        -- end loop;

        -- -- wait for 6 clk cycles
        -- wait for 60 ns;

        -- wait;

    end process;
    

    val1 <= data_out(11 downto 0);
    val2 <= data_out(23 downto 12);
    val3 <= data_out(35 downto 24);
    val4 <= data_out(47 downto 36);

    bval1 <= BF_out(11 downto 0);
    bval2 <= BF_out(23 downto 12);
    bval3 <= BF_out(35 downto 24);
    bval4 <= BF_out(47 downto 36);
end testbench;