require 'ffi/msgpack/types'
require 'ffi/msgpack/msg_object'

require 'ffi'
require 'enumerator'

module FFI
  module MsgPack
    extend FFI::Library

    ffi_lib 'msgpack'

    begin
      attach_function :msgpack_version, [], :string
      attach_function :msgpack_version_major, [], :int
      attach_function :msgpack_version_minor, [], :int
    rescue FFI::NotFoundError
    end

    #
    # The version of libmsgpack.
    #
    # @return [Gem::Version, nil]
    #   The version of `libmsgpack`. `nil` will be returned if the version
    #   of `libmsgpack` is <= 0.5.1.
    #
    # @since 0.1.4
    #
    def MsgPack.version
      if MsgPack.respond_to?(:msgpack_version)
        @version ||= Gem::Version.new(MsgPack.msgpack_version)
      end
    end

    attach_function :msgpack_object_print, [:pointer, MsgObject.by_value], :void
    #attach_function :msgpack_object_equal, [MsgObject, MsgObject.by_value], :bool

    attach_function :msgpack_zone_init, [:pointer, :size_t], :bool
    attach_function :msgpack_zone_destroy, [:pointer], :void
    attach_function :msgpack_zone_new, [:size_t], :pointer
    attach_function :msgpack_zone_free, [:pointer], :void
    attach_function :msgpack_zone_is_empty, [:pointer], :bool
    attach_function :msgpack_zone_clear, [:pointer], :void

    attach_function :msgpack_unpacker_init, [:pointer, :size_t], :bool
    attach_function :msgpack_unpacker_destroy, [:pointer], :void

    attach_function :msgpack_unpacker_new, [:size_t], :pointer
    attach_function :msgpack_unpacker_free, [:pointer], :void

    #attach_function :msgpack_unpacker_reserve_buffer, [:pointer, :size_t], :bool
    #attach_function :msgpack_unpacker_buffer, [:pointer], :pointer
    #attach_function :msgpack_unpacker_buffer_capacity, [:pointer], :size_t
    #attach_function :msgpack_unpacker_buffer_consumed, [:pointer, :size_t], :void

    attach_function :msgpack_unpacker_execute, [:pointer], :int

    attach_function :msgpack_unpacker_data, [:pointer], MsgObject.by_value

    attach_function :msgpack_unpacker_release_zone, [:pointer], :pointer

    attach_function :msgpack_unpacker_reset_zone, [:pointer], :void

    attach_function :msgpack_unpacker_reset, [:pointer], :void

    #attach_function :msgpack_unpacker_message_size, [:pointer], :size_t

    attach_function :msgpack_unpack, [:string, :size_t, :pointer, :pointer, :pointer], :msgpack_unpack_return

    #attach_function :msgpack_unpacker_parsed_size, [:pointer], :size_t

    attach_function :msgpack_unpacker_flush_zone, [:pointer], :bool

    attach_function :msgpack_unpacker_expand_buffer, [:pointer, :size_t], :bool

    #attach_function :msgpack_packer_init, [:pointer, :pointer, :msgpack_packer_write], :void

    #attach_function :msgpack_packer_new, [:pointer, :msgpack_packer_write], :pointer
    #attach_function :msgpack_packer_free, [:pointer], :void

    #attach_function :msgpack_pack_short, [:pointer, :short], :int
    #attach_function :msgpack_pack_int, [:pointer, :int], :int
    #attach_function :msgpack_pack_long, [:pointer, :long], :int
    #attach_function :msgpack_pack_long_long, [:pointer, :int64], :int
    #attach_function :msgpack_pack_unsigned_short, [:pointer, :ushort], :int
    #attach_function :msgpack_pack_unsigned_int, [:pointer, :uint], :int
    #attach_function :msgpack_pack_unsigned_long, [:pointer, :ulong], :int
    #attach_function :msgpack_pack_unsigned_long_long, [:pointer, :uint64], :int

    #attach_function :msgpack_pack_uint8, [:pointer, :uint8], :int
    #attach_function :msgpack_pack_uint16, [:pointer, :uint16], :int
    #attach_function :msgpack_pack_uint32, [:pointer, :uint32], :int
    #attach_function :msgpack_pack_uint64, [:pointer, :uint64], :int
    #attach_function :msgpack_pack_int8, [:pointer, :int8], :int
    #attach_function :msgpack_pack_int16, [:pointer, :int16], :int
    #attach_function :msgpack_pack_int32, [:pointer, :int32], :int
    #attach_function :msgpack_pack_int64, [:pointer, :int64], :int

    #attach_function :msgpack_pack_float, [:pointer, :float], :int
    #attach_function :msgpack_pack_double, [:pointer, :double], :int

    #attach_function :msgpack_pack_nil, [:pointer], :int
    #attach_function :msgpack_pack_true, [:pointer], :int
    #attach_function :msgpack_pack_false, [:pointer], :int

    #attach_function :msgpack_pack_array, [:pointer, :uint], :int

    #attach_function :msgpack_pack_map, [:pointer, :uint], :int

    #attach_function :msgpack_pack_raw, [:pointer, :size_t], :int

    #attach_function :msgpack_pack_raw_body, [:pointer, :buffer_in, :size_t], :int

    attach_function :msgpack_pack_object, [:pointer, MsgObject.by_value], :int

    #
    # Packs a Ruby object.
    #
    # @param [Array[Hash, Array, String, Symbol, Integer, Float, true, false, nil]] objs
    #   The Ruby object(s) to pack.
    #
    # @return [String]
    #   The packed Ruby object.
    #
    def MsgPack.pack(*objs)
      packer = Packer.create

      objs.each { |obj| packer << obj }

      return packer.to_s
    end

    #
    # Unpacks a packed object.
    #
    # @param [String] packed
    #   The packed object.
    #
    # @return [Hash, Array, String, Symbol, Integer, Float, true, false, nil]
    #   The first unpacked Ruby object.
    #
    def MsgPack.unpack(packed)
      unpacker = Unpacker.create(packed.length)
      unpacker << packed

      return unpacker.first
    end

  end
end
