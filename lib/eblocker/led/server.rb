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
require_relative 'animation'
require 'async/io'
require 'json'

module Eblocker::Led
  CONFIG_FILE = '/opt/eblocker-led/run/config.json'
  PROPERTIES_FILE = '/etc/eblocker-device.properties'

  class Server
    def initialize(endpoint)
      @hardware_available = false
      @endpoint = endpoint
      @animator = Eblocker::Led::Animator.new
      load_config()
      load_properties()
    end

    def load_config
      begin
        if File.exist?(CONFIG_FILE)
          cfg = JSON.parse(File.read(CONFIG_FILE))
          if cfg.has_key?('brightness')
            brightness = cfg['brightness']
            if brightness.is_a?(Float)
              @animator.brightness = brightness
            end
          end
        end
      rescue Exception => e
        Async.logger.error "Could not read configuration: #{e.message}. Continuing with default values."
      end
    end

    def load_properties
      if File.exist?(PROPERTIES_FILE)
        File.open(PROPERTIES_FILE) do |file|
          file.each_line do |line|
            if line =~ /^\s*device\.led\.rgb\.available\s*=\s*true\s*$/
              @hardware_available = true
            end
          end
        end
      end
    end

    def save_config
      begin
        cfg = {'brightness' => @animator.brightness}
        File.open(CONFIG_FILE, 'w') do |file|
          file.puts(cfg.to_json)
        end
      rescue Exception => e
        Async.logger.error "Could not save configuration: #{e.message}."
      end
    end

    def run
      if @hardware_available
        @animator.run()
      else
        Async.logger.info "LED hardware not available"
      end
      Async::Reactor.run do |task|
        @endpoint.accept do |client|
          begin
	    command = client.read(512).chomp

            if !@hardware_available
              client.write("hardware not available\n")
            elsif command =~ /^status=([a-z_]+)$/
              client.write(set_status($1.to_sym))
            elsif command =~ /^brightness=(\d+\.?\d*|\.\d+)$/
              client.write(set_brightness($1.to_f))
	    elsif command == 'status'
              client.write("#{@animator.status}\n")
            elsif command == 'brightness'
	      client.write("#{@animator.brightness}\n")
            else
              client.write("invalid command\n")
            end
          rescue Exception => e
            Async.logger.error "processing control message failed: #{e.message}"
          end
        end
      end
    end

    def set_status(status)
      if @animator.has_status?(status)
        @animator.status = status
        return "OK\n"
      else
        return "invalid status\n"
      end
    end

    def set_brightness(brightness)
      if brightness > 1.0
        return "invalid brightness\n"
      else
        @animator.brightness = brightness
        save_config()
        return "OK\n"
      end
    end

    def shutdown
      @animator.status = :shutting_down
    end
  end
end
