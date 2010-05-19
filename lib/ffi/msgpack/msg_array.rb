require 'ffi/msgpack/types'
require 'ffi/msgpack/msg_object'

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

      #
      # The Msg Object at the given index or a field within the Msg Array
      # Struct.
      #
      # @param [Symbol, Integer] key
      #   The Msg Array Struct field or index within the Array.
      #
      # @return [Object, MsgObject]
      #   The field within the Msg Array Struct or the Msg Object within
      #   the Array.
      #
      # @raise [ArgumentError]
      #   The given Array index is out of bounds.
      #
      def [](key)
        if key.kind_of?(Integer)
          if (key >= 0 && key < self[:size])
            MsgObject.new(self[:ptr].get_pointer(key))
          else
            raise(ArgumentError,"invalid array index: #{key}",calller)
          end
        else
          super(key)
        end
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
