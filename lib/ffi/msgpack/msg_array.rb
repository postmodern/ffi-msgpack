require 'ffi/msgpack/types'
require 'ffi/msgpack/msg_object'

module FFI
  module MsgPack
    class MsgArray < FFI::Struct

      layout :size, :uint32,
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

      #
      # The Array of values.
      #
      # @return [Array<Object>]
      #   The values contained within the Array.
      #
      def to_a
        (0...self.length).map do |index|
          MsgObject.new(self[:ptr][index * MsgObject.size]).to_ruby
        end
      end

    end
  end
end
