require 'ffi/msgpack/exceptions/parse_error'
require 'ffi/msgpack/types'
require 'ffi/msgpack/msgpack'

module FFI
  module MsgPack
    class Unpacker < FFI::Struct

      include Enumerable

      # Default chunk-size to expand the buffer by
      CHUNK_SIZE = 1024

      # The chunk-size to expand the buffer by
      attr_accessor :chunk_size

      # The optional stream to read packed data from
      attr_accessor :stream

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
        @stream = nil
      end

      def Unpacker.create(size)
        Unpacker.new(MsgPack.msgpack_unpacker_new(size))
      end

      def Unpacker.release(ptr)
        MsgPack.msgpack_unpacker_free(ptr)
      end

      def <<(packed)
        # make sure we have space in the buffer
        reserve_buffer(packed.length)

        # copy in the bytes
        self[:buffer].put_bytes(buffer_offset,packed)

        # advace the buffer position
        buffer_consumed!(packed.length)
        return self
      end

      def read(io)
        reserve_buffer(@chunk_size)
        result = io.read(buffer_capacity)

        unless (result.nil? || result.empty?)
          self << result
          return true
        else
          return false
        end
      end

      def each_object
        loop do
          ret = MsgPack.msgpack_unpacker_execute(self)

          if ret > 0
            # copy out the next Msg Object and release it's zone
            obj = MsgPack.msgpack_unpacker_data(self)
            zone = MsgPack.msgpack_unpacker_release_zone(self)

            # reset the unpacker
            MsgPack.msgpack_unpacker_reset(self)

            yield obj

            # free the zone now that we are done with it
            MsgPack.msgpack_zone_free(zone)
          elsif ret < 0
            raise(ParseError,"a parse error occurred",caller)
          else
            unless (@stream && read(@stream))
              break
            end
          end
        end

        return self
      end

      def each
        return enum_for(:each) unless block_given?

        each_object do |obj|
          yield obj.to_ruby
        end
      end

      protected

      def reserve_buffer(size)
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
