-- UART Controller
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.system_types.all;

entity UART_CONTROLLER is
    port (
        -- System signals
        clk         : in  std_logic;
        rst         : in  std_logic;
        -- UART signals
        rx_data     : in  std_logic_vector(7 downto 0);
        rx_done     : in  std_logic;
        tx_data     : out std_logic_vector(7 downto 0);
        tx_start    : out std_logic;
        tx_busy     : in  std_logic;
        -- RAM signals
        ram_en1     : out std_logic;
        ram_en2     : out std_logic;
        ram_addr1   : out std_logic_vector(ADDR_SIZE downto 0);
        ram_addr2   : out std_logic_vector(ADDR_SIZE downto 0);
        ram_we      : out std_logic;
        ram_data_in : out std_logic_vector(DATA_SIZE-1 downto 0);
        ram_data_out: in  std_logic_vector(DATA_SIZE-1 downto 0)
    );
end UART_CONTROLLER;

architecture RTL of UART_CONTROLLER is
    type state_type is (IDLE, GET_CMD, GET_ADDR, GET_DATA, SEND_DATA);
    signal state        : state_type := IDLE;
    signal byte_count   : integer range 0 to (DATA_SIZE/8) := 0;
    signal temp_addr    : std_logic_vector(ADDR_SIZE downto 0) := (others => '0');
    signal temp_data    : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');
    signal read_mode    : std_logic := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= IDLE;
                ram_en1 <= '0';
                ram_en2 <= '0';
                ram_we <= '0';
                tx_start <= '0';
            else
                tx_start <= '0';  -- Default value
                
                case state is
                    when IDLE =>
                        ram_we <= '0';
                        ram_en1 <= '0';
                        ram_en2 <= '0';
                        if rx_done = '1' then
                            state <= GET_CMD;
                        end if;
                        
                    when GET_CMD =>
                        if rx_done = '1' then
                            read_mode <= rx_data(0);  -- 0 = write, 1 = read
                            state <= GET_ADDR;
                        end if;
                        
                    when GET_ADDR =>
                        if rx_done = '1' then
                            temp_addr <= rx_data(ADDR_SIZE downto 0);
                            if read_mode = '1' then
                                ram_en2 <= '1';
                                ram_addr2 <= rx_data(ADDR_SIZE downto 0);
                                state <= SEND_DATA;
                                byte_count <= 0;
                            else
                                byte_count <= 0;
                                state <= GET_DATA;
                            end if;
                        end if;
                        
                    when GET_DATA =>
                        if rx_done = '1' then
                            temp_data <= rx_data & temp_data(DATA_SIZE-1 downto 8);
                            if byte_count = (DATA_SIZE/8)-1 then
                                ram_en1 <= '1';
                                ram_we <= '1';
                                ram_addr1 <= temp_addr;
                                ram_data_in <= temp_data;
                                state <= IDLE;
                            else
                                byte_count <= byte_count + 1;
                            end if;
                        end if;
                        
                    when SEND_DATA =>
                        if tx_busy = '0' then
                            if byte_count < (DATA_SIZE/8) then
                                tx_data <= ram_data_out((DATA_SIZE-1-byte_count*8) downto (DATA_SIZE-8-byte_count*8));
                                tx_start <= '1';
                                byte_count <= byte_count + 1;
                            else
                                ram_en2 <= '0';
                                state <= IDLE;
                            end if;
                        end if;
                end case;
            end if;
        end if;
    end process;
end RTL;