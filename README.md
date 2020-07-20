# eBlocker LED Controller

Controls an RGB LED via the Serial Peripheral Interface (SPI).

The service starts a TCP server on localhost, port 9000. This can be used to change the status.

## Prerequisites

*   Make sure the file `/etc/eblocker-device.properties` contains the line

        device.led.rgb.available = true

    Otherwise, the service will not attempt to control the LED.

*   The kernel must support the SPI device. The device file

        /dev/spidev0.0
        
    must exist.

## Run

Start the service:

    systemctl start eblocker-led

Change the status:

    echo "status=testloop" | nc localhost 9000

    echo "status=off" | nc localhost 9000

The initial status is `booting`.

## Build

Build a Debian package with

    make package
