require 'ffi/msgpack/packer'

module FFI
  module MsgPack
    module Packable
      #
      # Packs a Ruby Object.
      #
      # @return [String]
      #   The packed Object.
      #
      def to_msgpack
        packer = Packer.create
        packer << self

        return packer.to_s
      end
    end
  end
end
