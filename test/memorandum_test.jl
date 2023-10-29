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

import Memorandum: send!, messageidentifier

struct FooApplication <: Memorandum.Application
    messages::Vector{Any}

    FooApplication() = new([])
end

function hasmessage(app::FooApplication, message) :: Bool
    message in app.messages
end

send!(app::FooApplication, message::Any) = push!(app.messages, message)

struct BarApplication <: Memorandum.Application
    received::Vector{Any}

    BarApplication() = new([])
end


send!(app::BarApplication, message::Any) = push!(app.received, message)

function hasmessage(app::BarApplication, message) :: Bool
    message in app.received
end

struct MessageA end
struct MessageB end

messageidentifier(::MessageA) = MessageIdentifier("MessageA")
messageidentifier(::MessageB) = MessageIdentifier("MessageB")

@testset "Memorandum" begin

@testset "Subscription; Application Foo subscribes to message A; Foo receives a message A" begin
    # Arrange
    memo = MemorandumService()
    fooapp = FooApplication()
    registerapplication!(memo, fooapp)

    # Act
    subscribe!(memo, fooapp, MessageIdentifier("MessageA"))
    publish!(memo, MessageA())

    # Assert
    @test hasmessage(fooapp, MessageA())
end

@testset "Subscription; Application Bar subscribes to message A; Bar receives a message A" begin
    # This tests that the internal detail of how messages are sent to an application is abstracted.
    # The `BarApplication` struct has different fields that `FooApplication`.
    # Arrange
    memo = MemorandumService()
    barapp = BarApplication()
    registerapplication!(memo, barapp)

    # Act
    subscribe!(memo, barapp, MessageIdentifier("MessageA"))
    publish!(memo, MessageA())

    # Assert
    @test hasmessage(barapp, MessageA())
end

@testset "Subscription; Application Foo does not subscribe to message A; Foo does not receive a message A" begin
    # Arrange
    memo = MemorandumService()
    fooapp = FooApplication()
    registerapplication!(memo, fooapp)

    # Act
    publish!(memo, MessageA())

    # Assert
    @test !hasmessage(fooapp, MessageA())
end

@testset "Subscription; Application Foo subscribes to message A; Foo does not receive a message B" begin
    # Arrange
    memo = MemorandumService()
    fooapp = FooApplication()
    registerapplication!(memo, fooapp)

    # Act
    subscribe!(memo, fooapp, MessageIdentifier("MessageA"))
    publish!(memo, MessageB())

    # Assert
    @test !hasmessage(fooapp, MessageB())
end

@testset "Multiple subscriptions; Application Foo subscribes to message A; Foo receives message A" begin # Arrange
    memo = MemorandumService()
    fooapp = FooApplication()
    barapp = BarApplication()
    registerapplication!(memo, fooapp)
    registerapplication!(memo, barapp)

    # Act
    subscribe!(memo, fooapp, MessageIdentifier("MessageA"))
    publish!(memo, MessageA())

    # Assert
    @test hasmessage(fooapp, MessageA())
end

@testset "Multiple subscriptions; Application Bar subscribes to message A; Bar receives message A" begin # Arrange
    memo = MemorandumService()
    fooapp = FooApplication()
    barapp = BarApplication()
    registerapplication!(memo, fooapp)
    registerapplication!(memo, barapp)

    # Act
    subscribe!(memo, barapp, MessageIdentifier("MessageA"))
    publish!(memo, MessageA())

    # Assert
    @test hasmessage(barapp, MessageA())
end

@testset "Multiple subscriptions; Application Foo and Bar subscribe to message A; Foo and Bar receives message A" begin # Arrange
    memo = MemorandumService()
    fooapp = FooApplication()
    barapp = BarApplication()
    registerapplication!(memo, fooapp)
    registerapplication!(memo, barapp)

    # Act
    subscribe!(memo, fooapp, MessageIdentifier("MessageA"))
    subscribe!(memo, barapp, MessageIdentifier("MessageA"))
    publish!(memo, MessageA())

    # Assert
    @test hasmessage(fooapp, MessageA())
    @test hasmessage(barapp, MessageA())
end

end