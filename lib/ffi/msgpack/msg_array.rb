require 'ffi/msgpack/types'

module FFI
  module MsgPack
    class MsgArray < FFI::Struct

      layout :size, :size_t,
             :ptr, :pointer

      #
      # The length of the MsgPack Array.
      #
      # @return [Integer]
      #   The length of the Array.
      #
      def length
        self[:size]
      end

    end
  end
end
