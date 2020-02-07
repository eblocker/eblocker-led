#
# Copyright 2020 eBlocker Open Source UG (haftungsbeschraenkt)
#
# Licensed under the EUPL, Version 1.2 or - as soon they will be
# approved by the European Commission - subsequent versions of the EUPL
# (the "License"); You may not use this work except in compliance with
# the License. You may obtain a copy of the License at:
#
#   https://joinup.ec.europa.eu/page/eupl-text-11-12
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" basis,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied. See the License for the specific language governing
# permissions and limitations under the License.
#
module Eblocker::Led
  # Sets the color of an WS2812 RGB LED that is attached to the
  # Serial Peripheral Interface (SPI) of the board.
  #
  # For the timing specification, see:
  # https://cdn-shop.adafruit.com/datasheets/WS2812.pdf
  #
  # One data bit for the LED is encoded in one byte:
  # short pulse: 11000000 -> 0 bit
  # long pulse:  11111000 -> 1 bit
  #
  # A reset signal of at least 50 us ends the data refresh cycle.
  #
  class SpiDevice
    # These constants are defined in /usr/include/linux/spi/spidev.h
    SPI_IOC_WR_MODE = 1073834753
    SPI_IOC_WR_BITS_PER_WORD = 1073834755
    SPI_IOC_WR_MAX_SPEED_HZ = 1074031364

    SPI_DEVICE = "/dev/spidev0.0"

    def initialize
      device_file = SPI_DEVICE
      mode = [0].pack('C') # SPI_CS_HIGH;
      bits = [8].pack('C')
      speed = [4400000].pack('L') # => 8 bits are 1.82 microseconds

      fd = IO.sysopen(device_file, "r+b")
      @device = IO.new(fd)
    
      # Set mode
      @device.ioctl(SPI_IOC_WR_MODE, mode)

      # Set word length
      @device.ioctl(SPI_IOC_WR_BITS_PER_WORD, bits)

      # Set data rate
      @device.ioctl(SPI_IOC_WR_MAX_SPEED_HZ, speed)
    end
    
    def write data
      @device.write(data)
      @device.flush
    end

    # Encode an RGB color value
    # Parameters red, green, blue are integers from 0 to 255
    def encode(red, green, blue)
      lengthReset = 64 # RES = 116 us
      lengthData = 24
      length = lengthReset*2 + lengthData # one byte per bit

      data = ''

      bit0 = [0b11000000].pack('C') # T0H = 0.455 us, T0L = 1.364 us
      bit1 = [0b11111100].pack('C') # T1H = 1.364 us, T1L = 0.455 us
      reset = [0x00].pack('C')

      1.upto(lengthReset) do
        data << reset
      end

      [red, green, blue].each do |color|
        0.upto(7) do |i|
          bit = (((1 << (8 - i)) & color) > 0 ? bit1 : bit0)
          data << bit
        end
      end

      1.upto(lengthReset) do
        data << reset
      end
      data
    end
  end
end
