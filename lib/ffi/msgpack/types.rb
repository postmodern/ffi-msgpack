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

    callback :msgpack_packer_write, [:pointer, :pointer, :uint], :int

    enum :msgpack_object_type, [
      :msgpack_object_nil,              0x00,
      :msgpack_object_boolean,          0x01,
      :msgpack_object_positive_integer, 0x02,
      :msgpack_object_negative_integer, 0x03,
      :msgpack_object_double,           0x04,
      :msgpack_object_raw,              0x05,
      :msgpack_object_array,            0x06,
      :msgpack_object_map,              0x07
    ]

  end
end
