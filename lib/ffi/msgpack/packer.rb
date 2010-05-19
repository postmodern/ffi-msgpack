require 'ffi/msgpack/types'
require 'ffi/msgpack/msgpack'

module FFI
  module MsgPack
    class Packer < FFI::Struct

      layout :data, :pointer,
             :callback, :msgpack_packer_write

      attr_accessor :buffer

      #
      # Creates a new packer.
      #
      # @param [#<<] buffer
      #   Optional buffer to append packed Msg Objects to.
      #
      # @yield [user,data_ptr,length]
      #   If a block is given, it will be used as the callback to write
      #   the packed data.
      #
      # @yieldparam [FFI::Pointer] user
      #   Any user data.
      #
      # @yieldparam [FFI::Pointer] data_ptr
      #   The pointer to the packed data to be written.
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

        if block
          packer.buffer = nil

          # custom callback
          packer[:callback] = Proc.new(&block)
        else
          # set the buffer
          packer.buffer = (buffer || '')

          # setup the default callback
          packer[:callback] = Proc.new do |user,pack_ptr,length|
            packer.buffer << pack_ptr.get_bytes(0,length)
          end
        end

        return packer
      end

      #
      # Packs a Msg Object.
      #
      # @param [MsgObject] msg
      #   The Msg Object to pack.
      #
      def pack(msg)
        MsgPack.msgpack_pack_object(self,msg)
      end

      #
      # Packs a Ruby object.
      #
      # @param [Object] value
      #   The Ruby object to pack.
      #
      # @return [Packer]
      #   The packer.
      #
      def <<(value)
        pack(MsgObject.new_object(value))
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
        self.buffer.to_s if self.buffer
      end

      #
      # Inspects the packer.
      #
      # @return [String]
      #   The inspected packer.
      #
      def inspect
        addr = ('0x%x' % self.pointer.address)

        if self.buffer
          "#<#{self.class}:#{addr}: #{self.buffer.inspect}>"
        else
          "#<#{self.class}:#{addr}>"
        end
      end

    end
  end
end
