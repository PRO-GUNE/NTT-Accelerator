import serial
import time


class SerialCommunication:
    """
    Class to handle serial communication with read and write capabilities
    """

    def __init__(self, port="COM11", baudrate=115200):
        """Initialize serial communication parameters"""
        self.port = port
        self.baudrate = baudrate
        self.ser = None

    def open_connection(self):
        """Open serial connection with specified parameters"""
        try:
            self.ser = serial.Serial(
                port=self.port,
                baudrate=self.baudrate,
                bytesize=serial.EIGHTBITS,
                parity=serial.PARITY_NONE,
                stopbits=serial.STOPBITS_ONE,
                timeout=1,
            )
            return True
        except serial.SerialException as e:
            print(f"Error opening port {self.port}: {e}")
            return False

    def close_connection(self):
        """Close serial connection"""
        if self.ser and self.ser.is_open:
            self.ser.close()
            print("Serial connection closed")

    def write_data(self, data):
        """
        Write data to serial port

        Parameters:
        data (bytes or str): Data to send over serial
        """
        try:
            if not self.ser or not self.ser.is_open:
                if not self.open_connection():
                    return False

            # If data is string, encode it to bytes
            if isinstance(data, str):
                data = data.encode()

            # Send data
            self.ser.write(data)
            print(f"Sent {len(data)} bytes successfully")
            return True

        except Exception as e:
            print(f"Error writing data: {e}")
            return False

    def read_data(self, size=1024, timeout=1):
        """
        Read data from serial port

        Parameters:
        size (int): Maximum number of bytes to read
        timeout (float): Read timeout in seconds

        Returns:
        bytes: Data read from serial port, or None if error
        """
        try:
            if not self.ser or not self.ser.is_open:
                if not self.open_connection():
                    return None

            # Set timeout for this read operation
            self.ser.timeout = timeout

            # Read data
            data = self.ser.read(size)
            if data:
                print(f"Received {len(data)} bytes")
                return data
            else:
                print("No data received")
                return None

        except Exception as e:
            print(f"Error reading data: {e}")
            return None

    def read_until(self, terminator=b"\n", timeout=1):
        """
        Read data until terminator is found

        Parameters:
        terminator (bytes): Termination sequence
        timeout (float): Read timeout in seconds

        Returns:
        bytes: Data read from serial port, or None if error
        """
        try:
            if not self.ser or not self.ser.is_open:
                if not self.open_connection():
                    return None

            # Set timeout for this read operation
            self.ser.timeout = timeout

            # Read until terminator
            data = self.ser.read_until(terminator)
            if data:
                print(f"Received {len(data)} bytes")
                return data
            else:
                print("No data received")
                return None

        except Exception as e:
            print(f"Error reading data: {e}")
            return None


# Example usage
if __name__ == "__main__":
    # Example of writing binary data
    serial_comm = SerialCommunication(port="COM11", baudrate=115200)
    binary_data = bytes([0x30, 0x35, 0x32, 0x33, 0x34, 0x35])
    serial_comm.write_data(binary_data)
    serial_comm.close_connection()

    # Create serial communication instance
    serial_comm = SerialCommunication(port="COM11", baudrate=115200)

    # Write example
    serial_comm.write_data(bytes([0x52]))

    # Read example - wait for response
    response = serial_comm.read_data()
    if response:
        print(f"Received: {response.decode()}")

    # Clean up
    serial_comm.close_connection()
