require 'ffi'

module FFI
  module MsgPack
    class ZoneFinalizerArray < FFI::Struct

      layout :tail, :pointer,
             :end, :pointer,
             :array, :pointer

    end
  end
end
