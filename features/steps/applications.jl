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

using Behavior
using Memorandum

struct FooApp
end

struct FooMessage
    n::Int
end

@given("a registered application Foo") do context
    memo = context[:memo]
    registerapplication!(memo, FooApp)
end

@when("the application Foo is started") do context
    memo = context[:memo]
    startapplication!(memo, FooApp)
end

@then("a message can be sent to Foo") do context
    memo = context[:memo]
    message = FooMessage(1)
    send!(memo, FooApp, message)
end

@then("a message can be received from Foo") do context
    @fail "Implement me"
end