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
require 'hsluv'

module Eblocker::Led
  class Colors
    # Convert a color in hex to RGB, taking into account a brightness_factor between 0.0 and 1.0.
    # Return values are in the range [0, 255]
    def self.hex_to_rgb(hex, brightness_factor)
      hsluv = Hsluv.hex_to_hsluv(hex)
      hue = hsluv[0]
      saturation = hsluv[1]
      lightness = hsluv[2]*brightness_factor
      Hsluv.hsluv_to_rgb(hue, saturation, lightness).map {|v| (v * 255.0).round().to_i()}
    end
  end
end
