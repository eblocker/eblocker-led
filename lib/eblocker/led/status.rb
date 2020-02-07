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
# Defines a sequence (or a loop) of colors for each status.
# If the last frame has a duration an animation is looped.

# For the names of states, see also:
# https://github.com/eblocker/eblocker/blob/develop/eblocker-icapserver/src/main/java/org/eblocker/server/common/data/systemstatus/ExecutionState.java
module Eblocker::Led
  DEFAULT_STATUS = :booting

  ANIMATIONS = {
    testloop: # red, green, blue, black
      [
        {col: '#ff0000', ms: 250},
        {col: '#00ff00', ms: 250},
        {col: '#0000ff', ms: 250},
        {col: '#000000', ms: 250},
      ],
    booting: # blink blue
      [
        {col: '#0000ff', ms: 500},
        {col: '#000000', ms: 500}
      ],
    shutting_down: # yellow
      [
        {col: '#ffff00'}
      ],
    shutting_down_for_reboot: # yellow
      [
        {col: '#ffff00'}
      ],
    updating: # blink yellow
      [
        {col: '#ffff00', ms: 500},
        {col: '#000000', ms: 500}
      ],
    error: # blink red
      [
        {col: '#ff0000', ms: 500},
        {col: '#000000', ms: 500}
      ],
    running: # orange
      [
        {col: '#ea5a09'}
      ],
    self_check_ok: # green
      [
        {col: '#00ff00'}
      ],
    self_check_not_ok: #red
      [
        {col: '#ff0000'}
      ],
    off: # black
      [
        {col: '#000000'}
      ]
  }
end
