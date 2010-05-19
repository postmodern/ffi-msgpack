require 'ffi/msgpack/types'
require 'ffi/msgpack/msg_object_union'

module FFI
  module MsgPack
    class MsgObject < FFI::Struct

      layout :type, :msgpack_object_type,
             :values, MsgObjectUnion

      #
      # The type of the Msg Object.
      #
      # @return [Symbol]
      #   The type of the Msg Object.
      #
      def type
        self[:type]
      end

      #
      # Sets the type of the Msg Object.
      #
      # @param [Symbol] new_type
      #   The new type.
      #
      # @return [Symbol]
      #   The new type of the Msg Object.
      #
      def type=(new_type)
        self[:type] = new_type
      end

      #
      # The values of the Msg Object.
      #
      # @return [MsgObjectUnion]
      #   The values of the Msg Object.
      #
      def values
        self[:values]
      end

    end
  end
end
