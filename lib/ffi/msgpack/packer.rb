require 'ffi/msgpack/types'
require 'ffi/msgpack/msgpack'

module FFI
  module MsgPack
    class Packer < FFI::Struct

      layout :data, :pointer,
             :callback, :msgpack_packer_write

      # The optional buffer to write packed Msg Objects into.
      attr_accessor :buffer

      # The total length of the buffer
      attr_accessor :total

      #
      # Creates a new packer.
      #
      # @param [#<<] buffer
      #   Optional buffer to append packed Msg Objects to.
      #
      # @yield [packed(,length)]
      #   If a block is given, it will be used as the callback to write
      #   the packed data.
      #
      # @yieldparam [String] packed
      #   The packed bytes representing a Msg Object.
      #
      # @yieldparam [Integer] length
      #   The length of the packed data.
      #
      # @return [Packer]
      #   The new packer.
      #
      def Packer.create(buffer=nil,&block)
        packer = Packer.new()

        # zero the memory
        packer[:data] = nil
        packer[:callback] = nil

        # zero the total
        packer.total = 0

        if block
          # disable the buffer
          packer.buffer = nil

          # custom callback
          packer.callback(&block)
        else
          # set the buffer
          packer.buffer = (buffer || '')

          # setup the default callback
          packer.callback do |packed,length|
            packer.buffer << packed
          end
        end

        return packer
      end

      #
      # Creates a new {Packer}.
      #
      # @param [FFI::Pointer] ptr
      #   An optional pointer to an existing packer.
      #
      # @since 0.2.0
      #
      def initialize(ptr=nil)
        if ptr
          super(ptr)
        else
          super()
        end

        @object = MsgObject.new
      end

      #
      # Sets the write callback for the packer.
      #
      # @yield [packed(,length)]
      #   If a block is given, it will be used as the callback to write
      #   the packed data.
      #
      # @yieldparam [String] packed
      #   The packed bytes representing a Msg Object.
      #
      # @yieldparam [Integer] length
      #   The length of the packed data.
      #
      # @return [Proc]
      #   The new callback.
      #
      def callback(&block)
        self[:callback] = Proc.new do |data_ptr,packed_buffer,length|
          @total += length

          packed = packed_buffer.get_bytes(0,length)

          if block.arity == 2
            block.call(packed,length)
          else
            block.call(packed)
          end
          
          0 # return 0 to indicate success
        end
      end

      #
      # Packs a Msg Object.
      #
      # @param [MsgObject] msg
      #   The Msg Object to pack.
      #
      # @return [Integer]
      #   Returns 0 on a successful write, and -1 if an error occurred.
      #
      def pack(msg)
        MsgPack.msgpack_pack_object(self,msg)
      end

      #
      # Packs a Ruby object.
      #
      # @param [Hash, Array, String, Symbol, Integer, Float, true, false, nil] value
      #   The Ruby object to pack.
      #
      # @return [Packer]
      #   The packer.
      #
      def <<(value)
        @object.set!(value)

        pack(@object)
        return self
      end

      #
      # The contents of the buffer.
      #
      # @return [String, nil]
      #   The contents of the buffer, or `nil` if only a callback is being
      #   used to write the packed data.
      #
      def to_s
        @buffer.to_s if @buffer
      end

      #
      # Inspects the packer.
      #
      # @return [String]
      #   The inspected packer.
      #
      def inspect
        addr = ('0x%x' % self.pointer.address)

        if @buffer
          "#<#{self.class}:#{addr}: #{@buffer.inspect}>"
        else
          "#<#{self.class}:#{addr}>"
        end
      end

    end
  end
end
