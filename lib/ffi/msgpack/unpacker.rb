require 'ffi/msgpack/types'
require 'ffi/msgpack/msgpack'

module FFI
  module MsgPack
    class Unpacker < FFI::Struct

      layout :buffer, :pointer,
             :user, :size_t,
             :free, :size_t,
             :off, :size_t,
             :parsed, :size_t,
             :z, :pointer,
             :initial_buffer_size, :size_t,
             :ctx, :pointer

    end
  end
end
