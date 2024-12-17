-- Top Level Entity
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.system_types.all;

entity UART_RAM_SYSTEM is
    port (
        -- System signals
        clk        : in  std_logic;
        rst        : in  std_logic;
        -- UART physical interface
        rx_serial  : in  std_logic;
        tx_serial  : out std_logic;
        -- Debug signals
        debug_busy : out std_logic
    );
end UART_RAM_SYSTEM;

architecture RTL of UART_RAM_SYSTEM is
    -- Internal signals
    signal rx_data      : std_logic_vector(7 downto 0);
    signal rx_done      : std_logic;
    signal tx_data      : std_logic_vector(7 downto 0);
    signal tx_start     : std_logic;
    signal tx_busy      : std_logic;
    signal ram_en1      : std_logic;
    signal ram_en2      : std_logic;
    signal ram_addr1    : std_logic_vector(ADDR_SIZE downto 0);
    signal ram_addr2    : std_logic_vector(ADDR_SIZE downto 0);
    signal ram_we       : std_logic;
    signal ram_data_in  : std_logic_vector(DATA_SIZE-1 downto 0);
    signal ram_data_out : std_logic_vector(DATA_SIZE-1 downto 0);
begin
    -- UART Instance
    UART_INST : entity work.UART
        generic map (
            CLK_FREQ   => CLK_FREQ,
            BAUD_RATE  => BAUD_RATE,
            DATA_WIDTH => 8,
            PARITY_BIT => "NONE",
            STOP_BITS  => 1
        )
        port map (
            clk       => clk,
            rst       => rst,
            rx_serial => rx_serial,
            tx_serial => tx_serial,
            rx_data_out   => rx_data,
            rx_done   => rx_done,
            rx_error  => open,
            tx_data_in   => tx_data,
            tx_start_in  => tx_start,
            tx_busy   => tx_busy,
            tx_done   => open
        );
    
    -- UART Controller Instance
    UART_CTRL_INST : entity work.UART_CONTROLLER
        port map (
            clk         => clk,
            rst         => rst,
            rx_data     => rx_data,
            rx_done     => rx_done,
            tx_data     => tx_data,
            tx_start    => tx_start,
            tx_busy     => tx_busy,
            ram_en1     => ram_en1,
            ram_en2     => ram_en2,
            ram_addr1   => ram_addr1,
            ram_addr2   => ram_addr2,
            ram_we      => ram_we,
            ram_data_in => ram_data_in,
            ram_data_out=> ram_data_out
        );
    
    -- Dual Port RAM Instance
    RAM_INST : entity work.DUAL_PORT_RAM
        port map (
            clk      => clk,
            en1      => ram_en1,
            en2      => ram_en2,
            addr1    => ram_addr1,
            addr2    => ram_addr2,
            write_en => ram_we,
            data_in  => ram_data_in,
            data_out => ram_data_out
        );
    
    -- Debug signal
    debug_busy <= ram_we or ram_en2;
end RTL;