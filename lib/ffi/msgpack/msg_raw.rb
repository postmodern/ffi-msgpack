require 'ffi/msgpack/types'

module FFI
  module MsgPack
    class MsgRaw < FFI::Struct

      layout :size, :uint32,
             :ptr, :pointer

      #
      # Sets the contents of the Raw String.
      #
      # @param [String] data
      #   The values to populate the Raw String with.
      #
      # @return [MsgRaw]
      #   The populated Raw String.
      #
      # @since 0.1.5
      #
      def set(data)
        @buffer = FFI::MemoryPointer.new(:uchar, data.length)
        @buffer.put_bytes(0,data)

        self[:size] = data.length
        self[:ptr] = @buffer

        return self
      end

      #
      # The length of the raw data.
      #
      # @return [Integer]
      #   The length of the raw data.
      #
      def length
        self[:size]
      end

      #
      # The pointer to the raw data.
      #
      # @return [FFI::Pointer]
      #   The pointer to the raw data.
      #
      def raw
        self[:ptr]
      end

      #
      # The raw data.
      #
      # @return [String]
      #   The raw data.
      #
      def to_s
        self[:ptr].get_bytes(0,self[:size])
      end

    end
  end
end
