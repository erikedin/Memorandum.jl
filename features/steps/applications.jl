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
    memo::MemoProxy
end

# FooMessage is a test message that asks to increment the `n` field.
# The response will be a `FooResponseMessage` containing `n+1`.
struct FooRequestMessage
    n::Int
end

struct FooResponseMessage
    n::Int
end

# `sendmessage!` is a helper method that causes `FooApp` to send a message
# to the memo service.
function sendmessage!(fooapp::FooApp, message::FooRequestMessage)
    send!(fooapp.memo, message)
end

# `BarResponse` is the message defined for `BarApp` that corresponds
# to the `FooResponseMessage` message. The field `n` will be populated
# by the field `n` in `FooResponseMessage`
struct BarResponse
    n::Int
end

struct BarState
    responses::Vector{BarResponse}
    BarState() = new(BarResponse[])
end

struct BarApp
    memo::MemoProxy
    state::BarState

    BarApp(memo::MemoProxy) = new(memo, BarState())
end

function subscribeto!(barapp::BarApp, messageid::MessageIdentifier)
    subscribe!(barapp.memo, messageid)
end

function receivemessage!(barapp::BarApp)
    message = receive!(barapp.memo)
    push!(barapp.state.responses, message)
end

function hasmessage(barapp::BarApp, message::BarResponse)
    @test contains(barapp.state.responses, message)
end

@given("two running applications Foo and Bar") do context
    memo = context[:memo]

    fooapp = FooApp()
    startapplication!(memo, fooapp)
    barapp = BarApp()
    startapplication!(memo, barapp)

    context[:barapp] = barapp
    context[:fooapp] = fooapp
end

@given("the application Bar subscribes to the Foo message") do context
    barapp = context[:barapp]

    subscribeto!(barapp, MessageIdentifier("FooResponseMessage"))
end

@when("the application Foo sends a message") do context
    fooapp = context[:fooapp]

    message = FooMessage(1)
    sendmessage!(fooapp, message)
end

@then("the application Bar receives that message") do context
    barapp = context[:barapp]
    # Receive a single message from the memo service
    receivemessage!(barapp)
    @test hasmessage(barapp, BarResponse(2))
end