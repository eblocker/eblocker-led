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
require 'async/io'
require_relative 'status'
require_relative 'colors'
require_relative 'spi'

module Eblocker::Led

  # A sequence of frames that can be played on a
  # SPI device
  class Animation
    def initialize(frames)
      @frames = frames
    end

    def play(spi_device)
      @task = Async::Reactor.run do |t|
        run_loop = true
        while run_loop do
          @frames.each do |frame|
            spi_device.write(frame.encoded_color)
            if frame.duration_ms
              t.sleep(frame.duration_ms / 1000.0)
            else
              run_loop = false
            end
          end
        end
      end
    end

    # Stops an animation immediately (does not wait
    # for the last frame to end)
    def stop
      if @task
        @task.stop
      end
      @task = nil
    end
  end

  # A color with a duration. The color is already encoded
  # for the SPI device
  class Frame
    attr_accessor :encoded_color, :duration_ms

    # The duration might be nil, which means: stop the animation
    def initialize(encoded_color, duration_ms)
      @encoded_color = encoded_color
      @duration_ms = duration_ms
    end
  end

  # Encodes colors of an animation and starts it.
  # The animation is changed when attribute 'status'
  # is set.
  class Animator
    def initialize()
      @status = Eblocker::Led::DEFAULT_STATUS
      @brightness = 0.3
      @spi_device = SpiDevice.new
      @running = false
    end

    def status
      @status
    end

    def brightness
      @brightness
    end

    def has_status?(status)
      Eblocker::Led::ANIMATIONS.has_key?(status)
    end

    def status= status
      if has_status?(status)
        stop if @running
        @status = status
        run
      end
    end

    def brightness= brightness
      @brightness = brightness

      if @running
        stop
        run
      end
    end

    def run
      frame_definitions = Eblocker::Led::ANIMATIONS[@status]
      frames = frame_definitions.map do |fd|
        rgb = Eblocker::Led::Colors.hex_to_rgb(fd[:col], @brightness)
        encoded_color = @spi_device.encode(*rgb)
        Frame.new(encoded_color, fd[:ms])
      end

      @animation = Animation.new(frames)
      @animation.play(@spi_device)
      @running = true
    end

    def stop
      if @animation
        @animation.stop
        @animation = nil
      end
      @running = false
    end
  end
end
