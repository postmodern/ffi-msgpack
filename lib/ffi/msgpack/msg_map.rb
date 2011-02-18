require 'ffi/msgpack/types'

module FFI
  module MsgPack
    autoload :MsgKeyValue, 'ffi/msgpack/msg_key_value'

    class MsgMap < FFI::Struct

      layout :size, :uint32,
             :ptr, :pointer

      #
      # Sets the entries of the Map.
      #
      # @param [Hash] values
      #   The values to populate the Map with.
      #
      # @return [MsgMap]
      #   The populated Map.
      #
      # @since 0.1.5
      #
      def set(values)
        @entries = FFI::MemoryPointer.new(MsgKeyValue,values.length)

        values.each_with_index do |(key,value),index|
          pair = MsgKeyValue.new(@entries[index])

          MsgObject.new_object(key,pair[:key].to_ptr)
          MsgObject.new_object(value,pair[:value].to_ptr)
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
