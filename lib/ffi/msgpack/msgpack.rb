require 'ffi'

module FFI
  module MsgPack
    extend FFI::Library

    ffi_lib 'msgpack'
  end
end
