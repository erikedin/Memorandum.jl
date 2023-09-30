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

export MemorandumService, MemoProxy
export startapplication!
export MessageIdentifier
export send!, receive!, subscribe!

struct MemorandumService
end

struct MessageIdentifier
    messageid::String
end

const MemoProxy = MemorandumService

startapplication!(::MemorandumService, ::Any) = nothing
send!(::MemorandumService, ::Any, ::Any) = nothing
receive!(::MemorandumService) = nothing
subscribe!(::MemorandumService, messageid::MessageIdentifier) = nothing

end # module Memorandum
