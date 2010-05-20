require 'ffi/msgpack/types'
require 'ffi/msgpack/msgpack'

module FFI
  module MsgPack
    class Unpacker < FFI::Struct

      layout :buffer, :pointer,
             :used, :size_t,
             :free, :size_t,
             :off, :size_t,
             :parsed, :size_t,
             :z, :pointer,
             :initial_buffer_size, :size_t,
             :ctx, :pointer

      def Unpacker.create(size)
        Unpacker.new(MsgPack.msgpack_unpacker_new(size))
      end

      def Unpacker.release(ptr)
        MsgPack.msgpack_unpacker_free(ptr)
      end

      def reverse_buffer(size)
        if self[:free] >= size
          true
        else
          MsgPack.msgpack_unpacker_expand_buffer(self,size)
        end
      end

      def buffer
        self[:buffer] + self[:used]
      end

      def buffer_capacity
        self[:free]
      end

      def buffer_consumed!(size)
        self[:used] += size
        self[:free] -= size

        return nil
      end

      def message_size
        self[:parsed] - self[:off] + self[:used]
      end

      def parsed_size
        self[:parsed]
      end

    end
  end
end
