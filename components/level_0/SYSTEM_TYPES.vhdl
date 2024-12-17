-- Package file for common definitions
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package system_types is
    constant ADDR_SIZE : integer := 5;
    constant DATA_SIZE : integer := 64;
    constant CLK_FREQ : integer := 100_000_000;  -- 100MHz for Nexys A7
    constant BAUD_RATE : integer := 115200;
end package;