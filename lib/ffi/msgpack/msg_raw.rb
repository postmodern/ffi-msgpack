require 'ffi/msgpack/types'

module FFI
  module MsgPack
    class MsgRaw < FFI::Struct

      layout :size, :uint32,
             :ptr, :pointer

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
      # The raw data.
      #
      # @return [FFI::Pointer]
      #   The pointer to the raw data.
      #
      def data
        self[:ptr]
      end

    end
  end
end
