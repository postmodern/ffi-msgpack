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
      # @param [FFI::Pointer] ptr
      #   Optional pointer to create the Msg Object at.
      #
      # @return [MsgObject]
      #   A new Msg Object that represents the `nil` value.
      #
      def MsgObject.new_nil(ptr=nil)
        obj = MsgObject.new(ptr)
        obj[:type] = :nil

        return obj
      end

      #
      # Creates a new boolean Msg Object.
      #
      # @param [Boolean] value
      #   The boolean value.
      #
      # @param [FFI::Pointer] ptr
      #   Optional pointer to create the Msg Object at.
      #
      # @return [MsgObject]
      #   The new boolean Msg Object.
      #
      def MsgObject.new_boolean(value,ptr=nil)
        obj = MsgObject.new(ptr)
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
      # @param [FFI::Pointer] ptr
      #   Optional pointer to create the Msg Object at.
      #
      # @return [MsgObject]
      #   The new integer Msg Object.
      #
      def MsgObject.new_integer(value,ptr=nil)
        obj = MsgObject.new(ptr)

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
      # @param [FFI::Pointer] ptr
      #   Optional pointer to create the Msg Object at.
      #
      # @return [MsgObject]
      #   The floating-point Msg Object.
      #
      def MsgObject.new_double(value,ptr=nil)
        obj = MsgObject.new(ptr)
        obj[:type] = :double
        obj[:values][:dec] = value

        return obj
      end

      #
      # @see MsgObject.new_double
      #
      def MsgObject.new_float(value,ptr=nil)
        MsgObject.new_double(value,ptr)
      end

      #
      # Creates a new raw Msg Object.
      #
      # @param [String] data
      #   The raw data.
      #
      # @param [FFI::Pointer] ptr
      #   Optional pointer to create the Msg Object at.
      #
      # @return [MsgObject]
      #   The raw Msg Object.
      #
      def MsgObject.new_raw(data,ptr=nil)
        buffer = FFI::MemoryPointer.new(:uchar, data.length)
        buffer.put_bytes(0,data)

        obj = MsgObject.new(ptr)
        obj[:type] = :raw
        obj[:values][:raw][:size] = data.length
        obj[:values][:raw][:ptr] = buffer

        return obj
      end

      #
      # Creates a new array Msg Object.
      #
      # @param [Array] values
      #   The values for the array.
      #
      # @param [FFI::Pointer] ptr
      #   Optional pointer to create the Msg Object at.
      #
      # @return [MsgObject]
      #   The array Msg Object.
      #
      def MsgObject.new_array(values,ptr=nil)
        entries = FFI::MemoryPointer.new(MsgObject,values.length)

        values.each_with_index do |value,index|
          MsgObject.new_object(value,entries[index])
        end

        obj = MsgObject.new(ptr)
        obj[:type] = :array
        obj[:values][:array][:size] = values.length
        obj[:values][:array][:ptr] = entries

        return obj
      end

      #
      # Creates a Msg Object from a given Ruby object.
      #
      # @param [Object] value
      #   The Ruby object.
      #
      # @param [FFI::Pointer] ptr
      #   Optional pointer to create the Msg Object at.
      #
      # @return [MsgObject]
      #   The new Msg Object.
      #
      def MsgObject.new_object(value,ptr=nil)
        case value
        when Array
          MsgObject.new_array(value,ptr)
        when String
          MsgObject.new_raw(value,ptr)
        when Float
          MsgObject.new_double(value,ptr)
        when Integer
          MsgObject.new_integer(value,ptr)
        when TrueClass, FalseClass
          MsgObject.new_boolean(value,ptr)
        when NilClass
          MsgObject.new_nil(ptr)
        else
          raise(ArgumentError,"ambigious object to create MsgObject from: #{value.inspect}",caller)
        end
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
      def to_ruby
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
        when :raw
          self[:values][:raw].to_s
        when :array
          self[:values][:array].to_a
        else
          raise(RuntimeError,"unknown msgpack object type",caller)
        end
      end

    end
  end
end
