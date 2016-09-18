# encoding: utf-8
#
# Licensed to the Software Freedom Conservancy (SFC) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The SFC licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

module Selenium
  module WebDriver
    module Edge
      #
      # @api private
      #

      class Bridge < Remote::W3CBridge
        def initialize(opts = {})
          http_client = opts.delete(:http_client)

          if opts.key?(:url)
            url = opts.delete(:url)
          else
            @service = Service.new(Edge.driver_path, Service::DEFAULT_PORT)
            @service.host = 'localhost' if @service.host == '127.0.0.1'
            @service.start

            url = @service.uri
          end

          caps ||= Remote::W3CCapabilities.edge

          remote_opts = {
            url: url,
            desired_capabilities: caps
          }

          remote_opts[:http_client] = http_client if http_client
          super(remote_opts)
        end

        def browser
          :edge
        end

        def driver_extensions
          [
            DriverExtensions::TakesScreenshot,
            DriverExtensions::HasInputDevices
          ]
        end

        def capabilities
          @capabilities ||= Remote::Capabilities.edge
        end

        def quit
          super
        ensure
          @service.stop if @service
        end

      end # Bridge
    end # Edge
  end # WebDriver
end # Selenium
