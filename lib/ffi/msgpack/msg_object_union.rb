require 'ffi/msgpack/types'
require 'ffi/msgpack/msg_array'
require 'ffi/msgpack/msg_map'
require 'ffi/msgpack/msg_raw'

module FFI
  module MsgPack
    class MsgObjectUnion < FFI::Union

      layout :boolean, :bool,
             :u64, :uint64,
             :i64, :int64,
             :dec, :double,
             :array, MsgArray,
             :map, MsgMap,
             :raw, MsgRaw

    end
  end
end
