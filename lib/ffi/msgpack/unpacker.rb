require 'ffi/msgpack/exceptions/parse_error'
require 'ffi/msgpack/types'
require 'ffi/msgpack/msgpack'
require 'ffi/msgpack/zone'

require 'enumerator'

module FFI
  module MsgPack
    class Unpacker < FFI::Struct

      include Enumerable

      # Default chunk-size to expand the buffer by
      CHUNK_SIZE = 1024

      # The chunk-size to expand the buffer by
      attr_accessor :chunk_size

      layout :buffer, :pointer,
             :used, :size_t,
             :free, :size_t,
             :off, :size_t,
             :parsed, :size_t,
             :z, :pointer,
             :initial_buffer_size, :size_t,
             :ctx, :pointer

      def initialize(*arguments)
        super(*arguments)

        @chunk_size = CHUNK_SIZE
      end

      def Unpacker.create(size)
        Unpacker.new(MsgPack.msgpack_unpacker_new(size))
      end

      def Unpacker.release(ptr)
        MsgPack.msgpack_unpacker_free(ptr)
      end

      def read(io)
        reserve_buffer(@chunk_size)
        result = io.read(buffer_capacity)

        unless (result.nil? || result.empty?)
          buffer_consumed(self,result.length)
          return true
        else
          return false
        end
      end

      def each
        return enum_for(:each) unless block_given?

        loop do
          ret = MsgPack.msgpack_unpacker_execute(self)

          if ret > 0
            obj = MsgPack.msgpack_unpacker_data(self)
            zone = Zone.new(MsgPack.msgpack_unpacker_release_zone(self))

            MsgPack.msgpack_unpacker_reset(self)

            yield obj

            MsgPack.msgpack_zone_free(zone)
          elsif ret < 0
            raise(ParseError,"a parse error occurred",caller)
          else
            break
          end
        end

        return self
      end

      protected

      def reverse_buffer(size)
        if self[:free] >= size
          true
        else
          MsgPack.msgpack_unpacker_expand_buffer(self,size)
        end
      end

      def buffer_offset
        self[:used]
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
