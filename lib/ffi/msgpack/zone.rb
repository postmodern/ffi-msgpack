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

      #
      # Creates a new buffer zone.
      #
      # @param [Integer] chunk_size
      #   The chunk-size to use in the buffer zone.
      #
      # @return [Zone]
      #   The new buffer zone.
      #
      def Zone.create(chunk_size=CHUNK_SIZE)
        Zone.new(MsgPack.msgpack_zone_new(chunk_size))
      end

      #
      # Releases a previously created buffer zone.
      #
      # @param [FFI::Pointer] ptr
      #   The pointer to the buffer zone.
      #
      def Zone.release(ptr)
        MsgPack.msgpack_zone_free(ptr)
      end

      #
      # Determines whether the buffer zone is empty.
      #
      # @return [Boolean]
      #   Specifies if the buffer zone is empty.
      #
      def empty?
        MsgPack.msgpack_zone_is_empty(self)
      end

    end
  end
end
