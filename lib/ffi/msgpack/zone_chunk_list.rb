require 'ffi/msgpack/types'

module FFI
  module MsgPack
    class ZoneChunkList < FFI::Struct

      layout :free, :size_t,
             :ptr, :pointer,
             :head, :pointer

    end
  end
end
