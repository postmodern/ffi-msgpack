require 'ffi/msgpack/types'

module FFI
  module MsgPack
    autoload :MsgKeyValue, 'ffi/msgpack/msg_key_value'

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
      # The Hash of the Msg Maps keys and values.
      #
      # @return [Hash]
      #   The Hash of the key->value values.
      #
      def to_hash
        hash = {}

        (0...self.length).each do |index|
          pair = MsgKeyValue.new(self[:ptr][index * MsgKeyValue.size])

          hash[pair.key.to_ruby] = pair.value.to_ruby
        end

        return hash
      end

    end
  end
end
