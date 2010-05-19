require 'ffi/msgpack/types'
require 'ffi/msgpack/object'

require 'ffi'

module FFI
  module MsgPack
    extend FFI::Library

    ffi_lib 'msgpack'

    attach_function :msgpack_unpacker_init, [:pointer, :size_t], :bool
    attach_function :msgpack_unpacker_destroy, [:pointer], :void

    attach_function :msgpack_unpacker_new, [:size_t], :pointer
    attach_function :msgpack_unpacker_free, [:pointer], :void

    #attach_function :msgpack_unpacker_reserve_buffer, [:pointer, :size_t], :bool
    #attach_function :msgpack_unpacker_buffer, [:pointer], :pointer
    #attach_function :msgpack_unpacker_buffer_capacity, [:pointer], :size_t
    #attach_function :msgpack_unpacker_buffer_consumed, [:pointer, :size_t], :void

    attach_function :msgpack_unpacker_execute, [:pointer], :int

    attach_function :msgpack_unpacker_data, [:pointer], Object

    attach_function :msgpack_unpacker_release_zone, [:pointer], :pointer

    attach_function :msgpack_unpacker_reset_zone, [:pointer], :void

    attach_function :msgpack_unpacker_reset, [:pointer], :void

    #attach_function :msgpack_unpacker_message_size, [:pointer], :size_t

    attach_function :msgpack_unpack, [:pointer, :size_t, :pointer, :pointer, :pointer], :msgpack_unpack_return

    #attach_function :msgpack_unpacker_parsed_size, [:pointer], :size_t

    attach_function :msgpack_unpacker_flush_zone, [:pointer], :bool

    attach_function :msgpack_unpacker_expand_buffer, [:pointer, :size_t], :bool

  end
end
