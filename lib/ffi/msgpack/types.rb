require 'ffi'

module FFI
  module MsgPack
    extend FFI::Library

    typedef :int, :size_t

    enum :msgpack_unpack_return, [
      :success, 2,
      :extra_bytes, 1,
      :continue, 0,
      :parse_error, -1
    ]

    callback :msgpack_packer_write, [:pointer, :pointer, :uint], :int

    enum :msgpack_object_type, [
      :nil,              0x00,
      :boolean,          0x01,
      :positive_integer, 0x02,
      :negative_integer, 0x03,
      :double,           0x04,
      :raw,              0x05,
      :array,            0x06,
      :map,              0x07
    ]

  end
end
