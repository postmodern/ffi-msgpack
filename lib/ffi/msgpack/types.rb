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
      :nil,              0x01,
      :boolean,          0x02,
      :positive_integer, 0x03,
      :negative_integer, 0x04,
      :double,           0x05,
      :raw,              0x06,
      :array,            0x07,
      :map,              0x08
    ]

  end
end
