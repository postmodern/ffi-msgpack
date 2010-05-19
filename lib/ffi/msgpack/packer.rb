require 'ffi/msgpack/types'
require 'ffi/msgpack/msgpack'

module FFI
  module MsgPack
    class Packer < FFI::Struct

      layout :data, :pointer,
             :callback, :msgpack_packer_write

    end
  end
end
