library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity CONTROLLER is
    generic(
        BUFFER_SIZE : integer := 7;
        ADDR_DEPTH : integer := 5;
        DATA_SIZE : integer := 48;
        BAUD_DELAY : integer := 13020
    );

    port(
        clk              : in  std_logic;
        reset            : in  std_logic;
        tx_enable        : in  std_logic;
        rx               : in  std_logic;
        tx               : out std_logic;
        led              : out std_logic_vector(15 downto 0)
        );
end CONTROLLER;


architecture Behavioral of CONTROLLER is

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

    component DUAL_PORT_RAM is
        generic (
            ADDR_DEPTH : integer := 32;
            DATA_SIZE : integer := 48
        );
        port (
            clk       : in std_logic;
            en1       : in std_logic;
            en2       : in std_logic;
            addr1     : in integer range 0 to ADDR_DEPTH;
            addr2     : in integer range 0 to ADDR_DEPTH;
            write_en  : in std_logic;
            data_in   : in std_logic_vector(DATA_SIZE-1 downto 0);
            data_out : out std_logic_vector(DATA_SIZE-1 downto 0)
        );
    end component DUAL_PORT_RAM;

    signal button_pressed, tx_start, rx_valid : std_logic;
    signal new_data : std_logic := '0';
    signal rx_data_out, tx_data_in : std_logic_vector (7 downto 0);

    -- Internal signals using std_logic_vector
    signal data_buffer, result_buffer : std_logic_vector(8*BUFFER_SIZE-1 downto 0) := (others => '0');
    signal rx_count : integer range 0 to BUFFER_SIZE := 0;
    signal tx_count : integer range 0 to BUFFER_SIZE := 0;
    signal addr1, addr2 : integer range 0 to ADDR_DEPTH := 0;

    type state_type is (IDLE, RECEIVING, WAITING, TRANSMITTING);
    signal current_state : state_type := RECEIVING;
    
    signal delay_counter : integer range 0 to BAUD_DELAY := 0;
    signal transmit_active : boolean := false;

    -- Internal signals to connect RAM
    signal ram_data_in, ram_data_out : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');
    signal write_en : std_logic := '1';
    signal ram_port1_en, ram_port2_en : std_logic := '1';

begin
    ram : DUAL_PORT_RAM
    generic map(
        ADDR_DEPTH => ADDR_DEPTH,
        DATA_SIZE => DATA_SIZE
        )
    port map(
        clk => clk,
        en1 => ram_port1_en,
        en2 => ram_port2_en,
        write_en => write_en,
        addr1 => addr1,
        addr2 => addr2,
        data_in => ram_data_in,
        data_out => ram_data_out
        );

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
                addr1 <= 0;
                addr2 <= 0;
                delay_counter <= 0;

                new_data <= '1';
                tx_start <= '0';

                current_state <= IDLE;
                transmit_active <= false;
                
                data_buffer <= (others => '0');
                new_data <= '0';
                ram_data_in <= (others => '0');
                result_buffer <= (others => '0');
            else
                case current_state is
                    when IDLE => 
                        addr2 <= 0;
                        tx_start <= '0';
                        if rx_valid = '1' and new_data='1' then
                            current_state <= RECEIVING;
                        elsif rx_valid = '0' then
                            new_data <= '1';
                        end if;
                        led(0) <= '1';
                        led(15 downto 1) <= (others => '0');

                    when RECEIVING =>
                        tx_start <= '0';
                        
                        -- Store received byte in appropriate position within data_buffer
                        data_buffer(8*(rx_count+1)-1 downto 8*rx_count) <= rx_data_out;

                        if rx_count = BUFFER_SIZE-1 then
                            rx_count <= 0;                            
                            addr1 <= addr1;
                            ram_data_in <= data_buffer(8*(BUFFER_SIZE-1)-1 downto 0);    -- read the value

                            if addr1 = ADDR_DEPTH - 1 then
                                current_state <= WAITING;
                                addr1 <= 0;
                            else
                                current_state <= IDLE;
                                addr1 <= addr1 + 1;
                            end if;
                        else
                            rx_count <= rx_count + 1;
                            new_data <= '0';
                            current_state <= IDLE;
                        end if;
                        led(0) <= '0';
                        led(1) <= '1';
                        led(15 downto 2) <= (others => '0');

                    when WAITING =>
                        if button_pressed='1' then
                            tx_count <= 0;
                            result_buffer(47 downto 0) <= ram_data_out;
                            current_state <= TRANSMITTING;
                            delay_counter <= 0;
                            transmit_active <= false;
                        end if;
                        led(2) <= '1';
                        led(15 downto 3) <= (others => '0');
                        led(1 downto 0) <= (others => '0');
                        
                    when TRANSMITTING =>
                        if not transmit_active then
                            -- Extract appropriate byte from 
                            tx_data_in <= result_buffer(8*(tx_count+1)-1 downto 8*tx_count);
                            tx_start <= '1';
                            transmit_active <= true;
                            delay_counter <= 0;
                        else
                            tx_start <= '0';
                            if delay_counter = BAUD_DELAY then
                                if tx_count = BUFFER_SIZE-1 then
                                    if addr2 = ADDR_DEPTH-1 then
                                        current_state <= IDLE;
                                        addr1 <= 0;
                                    else
                                        current_state <= WAITING;
                                        addr2 <= addr2 + 1;
                                    end if;
                                    tx_count <= 0;
                                else
                                    tx_count <= tx_count + 1;
                                end if;
                                transmit_active <= false;
                            else
                                delay_counter <= delay_counter + 1;
                            end if;
                        end if;

                        led(3) <= '1';
                        led(15 downto 4) <= (others => '0');
                        led(2 downto 0) <= (others => '0');

                end case;
            end if;
        end if;
    end process;
    

end Behavioral;