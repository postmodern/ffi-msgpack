require 'ffi/msgpack/types'
require 'ffi/msgpack/msg_object'

module FFI
  module MsgPack
    class MsgKeyValue < FFI::Struct

      layout :key, :pointer,
             :value, :pointer

      #
      # The key.
      #
      # @return [MsgObject]
      #   The key Msg Object.
      #
      def key
        MsgObject.new(self[:key])
      end

      #
      # The value.
      #
      # @return [MsgObject]
      #   The value Msg Object.
      #
      def value
        MsgObject.new(self[:value])
      end

    end
  end
end
