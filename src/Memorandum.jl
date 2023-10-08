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

module Memorandum

export MemorandumService
export MessageIdentifier
export registerapplication!
export publish!, subscribe!, send!
export messageidentifier

struct MessageIdentifier
    messageid::String
end

messageidentifier(::Any) = error("Implement messageidentifier(::MessageType)")

abstract type Application end

send!(::Application, ::Any) = error("Implement send!(::Application, ::Any)")

mutable struct MemorandumService
    apps::Vector{Application}
    subscriptions::Set{MessageIdentifier}

    MemorandumService() = new(Application[], Set{MessageIdentifier}())
end

registerapplication!(memo::MemorandumService, app::Application) = push!(memo.apps, app)
subscribe!(memo::MemorandumService, ::Application, messageid::MessageIdentifier) = push!(memo.subscriptions, messageid)

function publish!(memo::MemorandumService, message::Any)
    if messageidentifier(message) in memo.subscriptions
        send!(memo.apps[1], message)
    end
end

end # module Memorandum
