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

struct FooApplication <: Memorandum.Application
    messages::Vector{Any}

    FooApplication() = new([])
end

function hasmessage(app::FooApplication, message) :: Bool
    message in app.messages
end

struct MessageA end

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

end