require 'ffi/msgpack/types'
require 'ffi/msgpack/msg_object'

module FFI
  module MsgPack
    class MsgArray < FFI::Struct

      layout :size, :uint32,
             :ptr, :pointer

      #
      # Sets the entries of the Array.
      #
      # @param [Array] values
      #   The values to populate the Array with.
      #
      # @return [MsgArray]
      #   The populated Array.
      #
      # @since 0.1.5
      #
      def set(values)
        @entries = FFI::MemoryPointer.new(MsgObject,values.length)

        values.each_with_index do |value,index|
          MsgObject.new_object(value,@entries[index])
        end

        self[:size] = values.length
        self[:ptr] = @entries

        return self
      end

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
