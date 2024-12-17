import serial
import time
import argparse


class RAMInterface:
    def __init__(self, port="COM3", baudrate=115200):
        self.ser = serial.Serial(
            port=port,
            baudrate=baudrate,
            parity=serial.PARITY_NONE,
            stopbits=serial.STOPBITS_ONE,
            bytesize=serial.EIGHTBITS,
        )
        print(f"Connected to {port} at {baudrate} baud")

    def write_to_ram(self, address, data, data_size=64):
        # Send command (0 for write)
        self.ser.write(bytes([0x00]))
        time.sleep(0.001)

        # Send address byte
        self.ser.write(bytes([address & 0xFF]))
        time.sleep(0.001)

        # Send data bytes
        for i in range(data_size // 8):
            byte = (data >> (i * 8)) & 0xFF
            self.ser.write(bytes([byte]))
            time.sleep(0.001)

        print(f"Written {hex(data)} to address {hex(address)}")

    def read_from_ram(self, address, data_size=64):
        # Send command (1 for read)
        self.ser.write(bytes([0x01]))
        time.sleep(0.001)

        # Send address byte
        self.ser.write(bytes([address & 0xFF]))
        time.sleep(0.001)

        # Read data bytes
        data = 0
        for i in range(data_size // 8):
            byte = int.from_bytes(self.ser.read(), byteorder="little")
            data |= byte << (i * 8)

        print(f"Read {hex(data)} from address {hex(address)}")
        return data

    def write_file_to_ram(self, filename, start_address=0):
        try:
            with open(filename, "r") as file:
                address = start_address
                for line in file:
                    # Remove whitespace and '0x' prefix if present
                    data = line.strip().replace("0x", "").replace(",", "")
                    if data:  # Skip empty lines
                        data_int = int(data, 16)
                        self.write_to_ram(address, data_int)
                        address += 1
                print(f"Successfully wrote data from {filename} to RAM")
        except FileNotFoundError:
            print(f"Error: File {filename} not found")
        except ValueError as e:
            print(f"Error parsing data: {e}")

    def read_ram_to_file(self, filename, start_address=0, num_words=32):
        try:
            with open(filename, "w") as file:
                for address in range(start_address, start_address + num_words):
                    data = self.read_from_ram(address)
                    file.write(f"0x{data:016x},\n")
                print(f"Successfully read RAM data to {filename}")
        except IOError as e:
            print(f"Error writing to file: {e}")

    def close(self):
        self.ser.close()
        print("Connection closed")


def main():
    parser = argparse.ArgumentParser(description="FPGA RAM Read/Write Interface")
    parser.add_argument("--port", default="COM3", help="Serial port (default: COM3)")
    parser.add_argument(
        "--baudrate", type=int, default=115200, help="Baudrate (default: 115200)"
    )

    subparsers = parser.add_subparsers(dest="command", help="Commands")

    # Write file to RAM
    write_parser = subparsers.add_parser("write", help="Write data from file to RAM")
    write_parser.add_argument("filename", help="Input file containing hex data")
    write_parser.add_argument(
        "--start-address", type=int, default=0, help="Starting address (default: 0)"
    )

    # Read RAM to file
    read_parser = subparsers.add_parser("read", help="Read data from RAM to file")
    read_parser.add_argument("filename", help="Output file for data")
    read_parser.add_argument(
        "--start-address", type=int, default=0, help="Starting address (default: 0)"
    )
    read_parser.add_argument(
        "--num-words",
        type=int,
        default=32,
        help="Number of words to read (default: 32)",
    )

    # Single word write
    write_word_parser = subparsers.add_parser(
        "write-word", help="Write single word to RAM"
    )
    write_word_parser.add_argument(
        "address", type=lambda x: int(x, 0), help="Address (in hex or decimal)"
    )
    write_word_parser.add_argument(
        "data", type=lambda x: int(x, 0), help="Data (in hex or decimal)"
    )

    # Single word read
    read_word_parser = subparsers.add_parser(
        "read-word", help="Read single word from RAM"
    )
    read_word_parser.add_argument(
        "address", type=lambda x: int(x, 0), help="Address (in hex or decimal)"
    )

    args = parser.parse_args()

    if not args.command:
        parser.print_help()
        return

    ram = RAMInterface(args.port, args.baudrate)

    try:
        if args.command == "write":
            ram.write_file_to_ram(args.filename, args.start_address)

        elif args.command == "read":
            ram.read_ram_to_file(args.filename, args.start_address, args.num_words)

        elif args.command == "write-word":
            ram.write_to_ram(args.address, args.data)

        elif args.command == "read-word":
            ram.read_from_ram(args.address)

    finally:
        ram.close()


if __name__ == "__main__":
    main()
