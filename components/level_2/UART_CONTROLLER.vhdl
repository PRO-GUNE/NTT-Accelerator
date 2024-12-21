library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity UART_controller is
    generic(
        BUFFER_SIZE : integer := 6;
        BAUD_DELAY : integer := 13020
    );

    port(
        clk              : in  std_logic;
        reset            : in  std_logic;
        tx_enable        : in  std_logic;
        rx               : in  std_logic;
        tx               : out std_logic
        );
end UART_controller;


architecture Behavioral of UART_controller is

    component button_debounce
        port(
            clk        : in  std_logic;
            reset      : in  std_logic;
            button_in  : in  std_logic;
            button_out : out std_logic
            );
    end component;


    component UART
        port(
            clk            : in  std_logic;
            reset          : in  std_logic;
            tx_start       : in  std_logic;
            rx_valid       : out std_logic;

            tx_data_in        : in  std_logic_vector (7 downto 0);
            rx_data_out       : out std_logic_vector (7 downto 0);

            rx             : in  std_logic;
            tx             : out std_logic
            );
    end component;

    signal button_pressed, tx_start, rx_valid, new_data : std_logic;
    signal rx_data_out, tx_data_in : std_logic_vector (7 downto 0);

    -- Internal signals using std_logic_vector
    signal data_buffer : std_logic_vector(8*BUFFER_SIZE-1 downto 0) := (others => '0');

    signal rx_count : integer range 0 to BUFFER_SIZE := 0;
    signal tx_count : integer range 0 to BUFFER_SIZE := 0;

    type state_type is (IDLE, RECEIVING, WAITING, TRANSMITTING);
    signal current_state : state_type := RECEIVING;
    
    signal delay_counter : integer range 0 to BAUD_DELAY := 0;
    signal transmit_active : boolean := false;

begin

    tx_button_controller: button_debounce
    port map(
            clk            => clk,
            reset          => reset,
            button_in      => tx_enable,
            button_out     => button_pressed
            );

    UART_transceiver: UART
    port map(
            clk            => clk,
            reset          => reset,
            tx_start       => tx_start,
            rx_valid       => rx_valid,
            tx_data_in     => tx_data_in,
            rx_data_out    => rx_data_out,
            rx             => rx,
            tx             => tx
            );

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                rx_count <= 0;
                tx_count <= 0;
                new_data <= '1';
                delay_counter <= 0;
                tx_start <= '0';
                current_state <= IDLE;
                transmit_active <= false;
                data_buffer <= (others => '0');
                
            else
                case current_state is
                    when IDLE => 
                        tx_start <= '0';
                        if rx_valid = '1' and new_data='1' then
                            current_state <= RECEIVING;
                        elsif rx_valid = '0' then
                            new_data <= '1';
                        end if;
                    when RECEIVING =>
                        tx_start <= '0';
                        
                        -- Store received byte in appropriate position within data_buffer
                        data_buffer(8*(rx_count+1)-1 downto 8*rx_count) <= rx_data_out;

                        if rx_count = BUFFER_SIZE-1 then
                            rx_count <= 0;
                            current_state <= WAITING;
                        else
                            rx_count <= rx_count + 1;
                            new_data <= '0';
                            current_state <= IDLE;
                        end if;
                        
                    when WAITING =>
                        if button_pressed='1' then
                            tx_count <= 0;
                            current_state <= TRANSMITTING;
                            delay_counter <= 0;
                            transmit_active <= false;
                        end if;
                        
                    when TRANSMITTING =>
                        if not transmit_active then
                            -- Extract appropriate byte from 
                            tx_data_in <= data_buffer(8*(tx_count+1)-1 downto 8*tx_count);
                            tx_start <= '1';
                            transmit_active <= true;
                            delay_counter <= 0;
                        else
                            tx_start <= '0';
                            if delay_counter = BAUD_DELAY then
                                if tx_count = BUFFER_SIZE-1 then
                                    current_state <= IDLE;
                                    tx_count <= 0;
                                else
                                    tx_count <= tx_count + 1;
                                end if;
                                transmit_active <= false;
                            else
                                delay_counter <= delay_counter + 1;
                            end if;
                        end if;
                end case;
            end if;
        end if;
    end process;
    
end Behavioral;