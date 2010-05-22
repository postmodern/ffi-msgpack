require 'ffi/msgpack/exceptions/parse_error'
require 'ffi/msgpack/types'
require 'ffi/msgpack/msgpack'

module FFI
  module MsgPack
    class Unpacker < FFI::Struct

      include Enumerable

      # Default chunk-size to expand the buffer by
      CHUNK_SIZE = 1024

      # The default size of the unpacker buffer
      DEFAULT_SIZE = CHUNK_SIZE * 4

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

      #
      # Initializes a new unpacker object.
      #
      def initialize(*arguments)
        super(*arguments)

        @chunk_size = CHUNK_SIZE
        @stream = nil
      end

      #
      # Creates a new unpacker object.
      #
      # @param [Integer] size
      #   The buffer size of the unpacker.
      #
      # @return [Unpacker]
      #   The new unpacker.
      #
      def Unpacker.create(size=DEFAULT_SIZE)
        Unpacker.new(MsgPack.msgpack_unpacker_new(size))
      end

      #
      # Destroys a previously allocated unpacker object.
      #
      # @param [FFI::Pointer] ptr
      #   The pointer to the allocated unpacker.
      #
      def Unpacker.release(ptr)
        MsgPack.msgpack_unpacker_free(ptr)
      end

      #
      # Writes packed data into the buffer of the unpacker.
      #
      # @param [String] packed
      #   The packed data.
      #
      # @return [Unpacker]
      #   The unpacker.
      #
      def <<(packed)
        # make sure we have space in the buffer
        reserve_buffer(packed.length)

        # copy in the bytes
        self[:buffer].put_bytes(buffer_offset,packed)

        # advace the buffer position
        buffer_consumed!(packed.length)
        return self
      end

      #
      # Reads packed data from a stream into the buffer of the unpacker.
      #
      # @param [IO] io
      #   The stream to read the packed data from.
      #
      # @return [Boolean]
      #   Specifies whether data was read from the stream, or if the stream
      #   is empty.
      #
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

      #
      # Enumerates over each Msg Object from the buffer in the unpacker.
      #
      # If {#stream} is set, packed data will be read from it, when the
      # buffer of the unpacker is fully unpacked.
      #
      # @yield [obj]
      #   The given block will be passed each Msg Object.
      #
      # @yieldparam [MsgObject] obj
      #   An unpacked Msg Object.
      #
      # @return [Unpacker]
      #   The unpacker.
      #
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

      #
      # Enumerates over each Msg Object from the buffer in the unpacker.
      #
      # @yield [obj]
      #   The given block will be passed each unpacked Ruby Object, from
      #   the buffer of the unpacker.
      #
      # @yieldparam [nil, true, false, Integer, Float, String, Array, Hash]  obj
      #   A Ruby Object unpacked from the buffer of the unpacker.
      #
      # @return [Enumerator, Unpacker]
      #   If no block is given, an enumerator will be returned.
      #
      def each
        return enum_for(:each) unless block_given?

        each_object do |obj|
          yield obj.to_ruby
        end
      end

      protected

      #
      # Reserves space in the buffer.
      #
      # @param [Integer] size
      #   The number of bytes to reserve.
      #
      # @return [Boolean]
      #   Specifies whether the size has been successfully reserved.
      #
      def reserve_buffer(size)
        if self[:free] >= size
          true
        else
          MsgPack.msgpack_unpacker_expand_buffer(self,size)
        end
      end

      #
      # The offset to empty space in the buffer.
      #
      # @return [Integer]
      #   The number of bytes within the buffer.
      #
      def buffer_offset
        self[:used]
      end

      #
      # The remaining space of the buffer.
      #
      # @return [Integer]
      #   The number of bytes free in the buffer.
      #
      def buffer_capacity
        self[:free]
      end

      #
      # Consums space in the buffer.
      #
      # @param [Integer] size
      #   The number of bytes to be consumed.
      #
      # @return [nil]
      #
      def buffer_consumed!(size)
        self[:used] += size
        self[:free] -= size

        return nil
      end

      #
      # The size of the unparsed message in the buffer.
      #
      # @return [Integer]
      #   The number of bytes that are unparsed.
      #
      def message_size
        self[:parsed] - self[:off] + self[:used]
      end

      #
      # The number of bytes that have been parsed in the buffer.
      #
      # @return [Integer]
      #   The number of parsed bytes.
      #
      def parsed_size
        self[:parsed]
      end

    end
  end
end
