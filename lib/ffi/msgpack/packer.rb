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
      # @yield [packer_ptr,data_ptr,length]
      #   If a block is given, it will be used as the callback to write
      #   the packed data.
      #
      # @yieldparam [FFI::Pointer] packer_ptr
      #   The pointer to the {Packer}.
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

        if buffer
          # set the buffer
          packer.buffer = buffer

          # setup the default callback
          packer[:callback] = Proc.new do |packer_ptr,data_ptr,length|
            packer.buffer << data_ptr.get_bytes(0,length)
          end
        elsif block
          # custom callback
          packer[:callback] = Proc.new(&block)
        end

        return packer
      end

    end
  end
end
