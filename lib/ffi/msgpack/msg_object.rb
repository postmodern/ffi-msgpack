require 'ffi/msgpack/types'
require 'ffi/msgpack/msg_object_union'

module FFI
  module MsgPack
    class MsgObject < FFI::Struct

      layout :type, :msgpack_object_type,
             :values, MsgObjectUnion

      #
      # Creates a new `nil` Msg Object.
      #
      # @return [MsgObject]
      #   A new Msg Object that represents the `nil` value.
      #
      def MsgObject.new_nil
        obj = MsgObject.new
        obj[:type] = :nil

        return obj
      end

      #
      # Creates a new boolean Msg Object.
      #
      # @param [Boolean] value
      #   The boolean value.
      #
      # @return [MsgObject]
      #   The new boolean Msg Object.
      #
      def MsgObject.new_boolean(value)
        obj = MsgObject.new
        obj[:type] = :boolean
        obj[:values][:boolean] = if value
                                   1
                                 else
                                   0
                                 end

        return obj
      end

      #
      # Creates a new integer Msg Object.
      #
      # @param [Integer] value
      #   The integer value.
      #
      # @return [MsgObject]
      #   The new integer Msg Object.
      #
      def MsgObject.new_integer(value)
        obj = MsgObject.new

        if value < 0
          obj[:type] = :negative_integer
          obj[:values][:i64] = value
        else
          obj[:type] = :positive_integer
          obj[:values][:u64] = value
        end

        return obj
      end

      #
      # Creates a new floating-point Msg Object.
      #
      # @param [Double, Float] value
      #   The floating-point value.
      #
      # @return [MsgObject]
      #   The floating-point Msg Object.
      #
      def MsgObject.new_double(value)
        obj = MsgObject.new
        obj[:type] = :double
        obj[:values][:dec] = value

        return obj
      end

      #
      # @see MsgObject.new_double
      #
      def MsgObject.new_float(value)
        MsgObject.new_double(value)
      end

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
      # The value of the Msg Object.
      #
      # @return [Object]
      #   The value of the Msg Object, expressed as a Ruby primitive.
      #
      # @raise [RuntimeError]
      #   The type of the Msg Object was unknown.
      #
      def value
        case self[:type]
        when :nil
          nil
        when :boolean
          if self[:values][:boolean] == 0
            false
          else
            true
          end
        when :positive_integer
          self[:values][:u64]
        when :negative_integer
          self[:values][:i64]
        when :double
          self[:values][:dec]
        else
          raise(RuntimeError,"unknown msgpack object type",caller)
        end
      end

    end
  end
end
