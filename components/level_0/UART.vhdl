library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UART is
    generic (
        CLK_FREQ      : integer := 100_000_000;   -- System clock frequency (default 100MHz)
        BAUD_RATE     : integer := 115200;        -- UART baud rate
        DATA_WIDTH    : integer := 8;             -- Data width
        PARITY_BIT    : string  := "NONE";        -- "NONE", "EVEN", "ODD"
        STOP_BITS     : integer := 1              -- Number of stop bits
    );
    port (
        -- System signals
        clk          : in  std_logic;
        rst          : in  std_logic;
        
        -- UART physical interface
        rx_serial    : in  std_logic;
        tx_serial    : out std_logic;
        
        -- TX Control
        tx_data_in      : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        tx_start_in     : in  std_logic;
        tx_busy      : out std_logic;
        tx_done      : out std_logic;
        
        -- RX Control
        rx_data_out      : out std_logic_vector(DATA_WIDTH-1 downto 0);
        rx_done      : out std_logic;
        rx_error     : out std_logic  -- Parity error or invalid stop bit
    );
end UART;

architecture RTL of UART is
    -- Derived constants
    constant CLKS_PER_BIT : integer := CLK_FREQ/BAUD_RATE;
    
    -- Receiver signals
    type rx_state_type is (RX_IDLE, RX_START, RX_DATA, RX_PARITY, RX_STOP);
    signal rx_state     : rx_state_type := RX_IDLE;
    signal rx_clk_count : integer range 0 to CLKS_PER_BIT-1 := 0;
    signal rx_bit_index : integer range 0 to DATA_WIDTH-1 := 0;
    signal rx_shift_reg : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal rx_parity_sig : std_logic := '0';
    
    -- Transmitter signals
    type tx_state_type is (TX_IDLE, TX_START, TX_DATA, TX_PARITY, TX_STOP);
    signal tx_state     : tx_state_type := TX_IDLE;
    signal tx_clk_count : integer range 0 to CLKS_PER_BIT-1 := 0;
    signal tx_bit_index : integer range 0 to DATA_WIDTH-1 := 0;
    signal tx_shift_reg : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '1');
    signal tx_parity_sig : std_logic := '0';
    signal stop_bit_count : integer range 0 to STOP_BITS := 0;
    
begin
    -- UART Receiver Process
    RX_PROC : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                rx_state <= RX_IDLE;
                rx_done <= '0';
                rx_error <= '0';
            else
                rx_done <= '0';  -- Default state
                rx_error <= '0';
                
                case rx_state is
                    when RX_IDLE =>
                        if rx_serial = '0' then  -- Start bit detected
                            rx_clk_count <= 0;
                            rx_state <= RX_START;
                        end if;
                        
                    when RX_START =>
                        if rx_clk_count = CLKS_PER_BIT/2 then
                            if rx_serial = '0' then  -- Confirm start bit
                                rx_clk_count <= 0;
                                rx_bit_index <= 0;
                                rx_parity_sig <= '0';
                                rx_state <= RX_DATA;
                            else
                                rx_state <= RX_IDLE;
                            end if;
                        else
                            rx_clk_count <= rx_clk_count + 1;
                        end if;
                        
                    when RX_DATA =>
                        if rx_clk_count = CLKS_PER_BIT-1 then
                            rx_clk_count <= 0;
                            rx_shift_reg(rx_bit_index) <= rx_serial;
                            rx_parity_sig <= rx_parity_sig xor rx_serial;
                            
                            if rx_bit_index = DATA_WIDTH-1 then
                                rx_bit_index <= 0;
                                if PARITY_BIT /= "NONE" then
                                    rx_state <= RX_PARITY;
                                else
                                    rx_state <= RX_STOP;
                                end if;
                            else
                                rx_bit_index <= rx_bit_index + 1;
                            end if;
                        else
                            rx_clk_count <= rx_clk_count + 1;
                        end if;
                        
                    when RX_PARITY =>
                        if rx_clk_count = CLKS_PER_BIT-1 then
                            rx_clk_count <= 0;
                            if (PARITY_BIT = "EVEN" and rx_parity_sig /= rx_serial) or
                               (PARITY_BIT = "ODD" and rx_parity_sig = rx_serial) then
                                rx_error <= '1';
                            end if;
                            rx_state <= RX_STOP;
                        else
                            rx_clk_count <= rx_clk_count + 1;
                        end if;
                        
                    when RX_STOP =>
                        if rx_clk_count = CLKS_PER_BIT-1 then
                            if rx_serial = '1' then  -- Valid stop bit
                                rx_done <= '1';
                                rx_data_out <= rx_shift_reg;
                            else
                                rx_error <= '1';
                            end if;
                            rx_state <= RX_IDLE;
                        else
                            rx_clk_count <= rx_clk_count + 1;
                        end if;
                end case;
            end if;
        end if;
    end process;
    
    -- UART Transmitter Process
    TX_PROC : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                tx_state <= TX_IDLE;
                tx_serial <= '1';
                tx_busy <= '0';
                tx_done <= '0';
            else
                tx_done <= '0';  -- Default state
                
                case tx_state is
                    when TX_IDLE =>
                        tx_serial <= '1';
                        tx_busy <= '0';
                        if tx_start_in = '1' then
                            tx_shift_reg <= tx_data_in;
                            tx_parity_sig <= '0';
                            tx_clk_count <= 0;
                            tx_state <= TX_START;
                            tx_busy <= '1';
                        end if;
                        
                    when TX_START =>
                        tx_serial <= '0';  -- Start bit
                        if tx_clk_count = CLKS_PER_BIT-1 then
                            tx_clk_count <= 0;
                            tx_bit_index <= 0;
                            tx_state <= TX_DATA;
                        else
                            tx_clk_count <= tx_clk_count + 1;
                        end if;
                        
                    when TX_DATA =>
                        tx_serial <= tx_shift_reg(tx_bit_index);
                        tx_parity_sig <= tx_parity_sig xor tx_shift_reg(tx_bit_index);
                        
                        if tx_clk_count = CLKS_PER_BIT-1 then
                            tx_clk_count <= 0;
                            if tx_bit_index = DATA_WIDTH-1 then
                                tx_bit_index <= 0;
                                if PARITY_BIT /= "NONE" then
                                    tx_state <= TX_PARITY;
                                else
                                    tx_state <= TX_STOP;
                                    stop_bit_count <= 0;
                                end if;
                            else
                                tx_bit_index <= tx_bit_index + 1;
                            end if;
                        else
                            tx_clk_count <= tx_clk_count + 1;
                        end if;
                        
                    when TX_PARITY =>
                        if PARITY_BIT = "EVEN" then
                            tx_serial <= tx_parity_sig;
                        else  -- ODD
                            tx_serial <= not tx_parity_sig;
                        end if;
                        
                        if tx_clk_count = CLKS_PER_BIT-1 then
                            tx_clk_count <= 0;
                            tx_state <= TX_STOP;
                            stop_bit_count <= 0;
                        else
                            tx_clk_count <= tx_clk_count + 1;
                        end if;
                        
                    when TX_STOP =>
                        tx_serial <= '1';  -- Stop bit
                        if tx_clk_count = CLKS_PER_BIT-1 then
                            tx_clk_count <= 0;
                            if stop_bit_count = STOP_BITS then
                                tx_done <= '1';
                                tx_state <= TX_IDLE;
                                stop_bit_count <= 0;
                            else
                                stop_bit_count <= stop_bit_count + 1;
                            end if;
                        else
                            tx_clk_count <= tx_clk_count + 1;
                        end if;
                end case;
            end if;
        end if;
    end process;
    
end RTL;