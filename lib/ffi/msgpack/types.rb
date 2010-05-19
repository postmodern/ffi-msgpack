require 'ffi'

module FFI
  module MsgPack
    extend FFI::Library

    typedef :int, :size_t

    enum :msgpack_unpack_return, [
      :msgpack_unpack_success, 2,
      :msgpack_unpack_extra_bytes, 1,
      :msgpack_unpack_continue, 0,
      :msgpack_unpack_parse_error, -1
    ]
  end
end
