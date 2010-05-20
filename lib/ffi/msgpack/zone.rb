require 'ffi/msgpack/types'
require 'ffi/msgpack/zone_chunk_list'
require 'ffi/msgpack/zone_finalizer_array'

module FFI
  module MsgPack
    class Zone < FFI::Struct

      # Default chunk-size
      CHUNK_SIZE = 8192

      layout :chunk_list, ZoneChunkList,
             :finalizer_array, ZoneFinalizerArray,
             :chunk_size, :size_t

    end
  end
end
