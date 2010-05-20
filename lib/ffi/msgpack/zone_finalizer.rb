require 'ffi'

module FFI
  module MsgPack
    class ZoneFinalizer < FFI::Struct

      callback :zone_finalizer_callback, [:pointer], :void

      layout :func, :zone_finalizer_callback,
             :data, :pointer

    end
  end
end
