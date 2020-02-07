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
require 'eblocker/led/server'
require 'async/io'
require 'process/daemon'

module Eblocker::Led
  ADDRESS = '127.0.0.1'
  #ADDRESS = '0.0.0.0' # allow remote control
  PORT = 9000

  class Daemon < Process::Daemon
    def startup
    end

    def run
      Async.logger.level = Logger::INFO
      Async::Reactor.run do |task|
        endpoint = Async::IO::Endpoint.tcp(ADDRESS, PORT)
        @server = Eblocker::Led::Server.new(endpoint)
        @server.run()
      end
    end

    def shutdown
      if @server
        @server.shutdown
      end
    end

    def name
      'eblocker-led'
    end
  end

  Daemon.daemonize # run in background
  #Daemon.new.run # run in foreground
end
