# Copyright 2023 Erik Edin
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

Feature: Starting applications

  Scenario: Start an application
    Given a memorandum
      And a registered application Foo
     When the application Foo is started
     Then a message can be sent to Foo
      And a message can be received from Foo

  Scenario: Relay a message from one application to another
    Given a memorandum
      And two running applications Foo and Bar
     When the application Foo sends a message for Bar
     Then the application Bar receives that message