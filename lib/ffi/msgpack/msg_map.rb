require 'ffi/msgpack/types'
require 'ffi/msgpack/msg_key_value'

module FFI
  module MsgPack
    class MsgMap < FFI::Struct

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
      # The Msg Object at the given index or a field within the Msg Map
      # Struct.
      #
      # @param [Symbol, Integer] key
      #   The Msg Map Struct field or index within the Map.
      #
      # @return [Object, MsgKeyValue]
      #   The field within the Msg Map Struct or the Msg key-value within
      #   the Map.
      #
      # @raise [ArgumentError]
      #   The given Map index is out of bounds.
      #
      def [](key)
        if key.kind_of?(Integer)
          if (key >= 0 && key < self[:size])
            MsgKeyValue.new(self[:ptr].get_pointer(key))
          else
            raise(ArgumentError,"invalid map index: #{key}",calller)
          end
        else
          super(key)
        end
      end

    end
  end
end
