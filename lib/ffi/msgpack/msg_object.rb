require 'ffi/msgpack/types'
require 'ffi/msgpack/msg_object_union'

module FFI
  module MsgPack
    class MsgObject < FFI::Struct

      layout :type, :msgpack_object_type,
             :values, MsgObjectUnion

      #
      # Initializes a new Msg Object.
      #
      # @param [FFI::Pointer] ptr
      #   An optional pointer to an existing Msg Object.
      #
      def initialize(ptr=nil)
        @object = nil
        @memory = nil

        if ptr
          super(ptr)
        else
          super()
        end
      end

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
        obj.set_nil!
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
        obj.set_boolean!(value)
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
        obj.set_integer!(value)
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
        obj.set_double!(value)
        return obj
      end

      #
      # @see MsgObject.new_double
      #
      def MsgObject.new_float(value,ptr=nil)
        obj = MsgObject.new(ptr)
        obj.set_double!(value)
        return obj
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
        obj = MsgObject.new(ptr)
        obj.set_raw!(data)
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
        obj = MsgObject.new(ptr)
        obj.set_array!(values)
        return obj
      end

      #
      # Creates a new map Msg Object.
      #
      # @param [Hash] values
      #   The values for the map.
      #
      # @param [FFI::Pointer] ptr
      #   Optional pointer to create the Msg Object at.
      #
      # @return [MsgObject]
      #   The map Msg Object.
      #
      def MsgObject.new_map(values,ptr=nil)
        obj = MsgObject.new(ptr)
        obj.set_map!(values)
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
        obj = MsgObject.new(ptr)
        obj.set!(value)
        return obj
      end

      #
      # Sets the Msg Objects value to nil.
      #
      # @since 0.2.0
      #
      def set_nil!
        @objects = nil
        @memory = nil

        self[:type] = :nil
      end

      #
      # Sets the Msg Objects value to a Boolean value.
      #
      # @param [Boolean] value
      #   The Boolean value.
      #
      # @since 0.2.0
      #
      def set_boolean!(value)
        @objects = nil
        @memory = nil

        self[:type] = :boolean
        self[:values][:boolean] = if value
                                   1
                                 else
                                   0
                                 end
      end

      #
      # Sets the Msg Objects value to an Integer value.
      #
      # @param [Integer] value
      #   The Integer value.
      #
      # @since 0.2.0
      #
      def set_integer!(value)
        @objects = nil
        @memory = nil

        if value < 0
          self[:type] = :negative_integer
          self[:values][:i64] = value
        else
          self[:type] = :positive_integer
          self[:values][:u64] = value
        end
      end

      #
      # Sets the Msg Objects value to a Floating Point value.
      #
      # @param [Float] value
      #   The Floating Point value.
      #
      # @since 0.2.0
      #
      def set_double!(value)
        @objects = nil
        @memory = nil

        self[:type] = :double
        self[:values][:dec] = value
      end

      alias set_float! set_double!

      #
      # Sets the Msg Objects value to a String value.
      #
      # @param [String, Symbol] value
      #   The String value.
      #
      # @since 0.2.0
      #
      def set_raw!(value)
        value = value.to_s

        @objects = nil
        @memory = FFI::MemoryPointer.new(:uchar, value.length) 
        @memory.put_bytes(0,value)

        self[:type] = :raw

        raw = self[:values][:raw]
        raw[:size] = value.length
        raw[:ptr] = @memory
      end

      #
      # Sets the Msg Objects value to an Array value.
      #
      # @param [Array] value
      #   The Array value.
      #
      # @since 0.2.0
      #
      def set_array!(values)
        @objects = []
        @memory = FFI::MemoryPointer.new(MsgObject,values.length)

        values.each_with_index do |value,index|
          @objects << MsgObject.new_object(value,@memory[index])
        end

        self[:type] = :array

        array = self[:values][:array]
        array[:size] = values.length
        array[:ptr] = @memory
      end

      #
      # Sets the Msg Objects value to a Map value.
      #
      # @param [Hash] value
      #   The Map value.
      #
      # @since 0.2.0
      #
      def set_map!(values)
        @objects = {}
        @memory = FFI::MemoryPointer.new(MsgKeyValue,values.length)

        values.each_with_index do |(key,value),index|
          pair = MsgKeyValue.new(@memory[index])

          key_obj = MsgObject.new_object(key,pair[:key].to_ptr)
          value_obj = MsgObject.new_object(value,pair[:value].to_ptr)

          @objects[key_obj] = value_obj
        end

        self[:type] = :map

        map = self[:values][:map]
        map[:size] = values.length
        map[:ptr] = @memory
      end

      #
      # Sets the contents of the Msg Object using a Ruby Object.
      #
      # @param [Object] value
      #   The Ruby object.
      #
      # @return [MsgObject]
      #   The new Msg Object.
      #
      # @raise [ArgumentError]
      #   The object was not a {Hash}, {Array}, {String}, {Symbol}, {Float},
      #   {Integer}, `true`, `false` or `nil`.
      #
      # @since 0.2.0
      #
      def set!(value)
        case value
        when Hash
          set_map!(value)
        when Array
          set_array!(value)
        when String, Symbol
          set_raw!(value)
        when Float
          set_double!(value)
        when Integer
          set_integer!(value)
        when TrueClass, FalseClass
          set_boolean!(value)
        when NilClass
          set_nil!
        else
          raise(ArgumentError,"ambigious object to create MsgObject from: #{value.inspect}",caller)
        end

        return value
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
      # The union of values for the Msg Object.
      #
      # @return [MsgObjectUnion]
      #   The union of values.
      #
      def values
        self[:values]
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
        when :map
          self[:values][:map].to_hash
        else
          raise(RuntimeError,"unknown msgpack object type",caller)
        end
      end

    end
  end
end
