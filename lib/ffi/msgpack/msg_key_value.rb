require 'ffi/msgpack/types'
require 'ffi/msgpack/msg_object'

module FFI
  module MsgPack
    class MsgKeyValue < FFI::Struct

      layout :key, MsgObject,
             :value, MsgObject

      #
      # The key.
      #
      # @return [MsgObject]
      #   The key Msg Object.
      #
      def key
        self[:key]
      end

      #
      # The value.
      #
      # @return [MsgObject]
      #   The value Msg Object.
      #
      def value
        self[:value]
      end

    end
  end
end
