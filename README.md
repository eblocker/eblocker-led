# eBlocker LED Controller

Controls an RGB LED via the Serial Peripheral Interface (SPI).

The service starts a TCP server on localhost, port 9000. This can be used to change the status.


## Run

Start the service:

    /opt/eblocker-led/bin/eblocker-led start

Change the status:

    echo "status=testloop" | nc localhost 9000

    echo "status=off" | nc localhost 9000

The initial status is `booting`.

## Build

Build a Debian package with

    make package
