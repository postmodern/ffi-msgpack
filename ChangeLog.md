### 0.1.3 / 2010-07-03

* Added specs for {FFI::MsgPack::Packable}.
* {FFI::MsgPack.pack} now accepts multiple arguments.
* Fixed a typo in {FFI::MsgPack::Packable#to_msgpack} (thanks bb).
* Fixed the packing of {Hash} objects.
  * Fixed the struct layout of {FFI::MsgPack::MsgKeyValue}.

### 0.1.2 / 2010-05-24

* Require libmsgpack >= 0.5.0, due to changes in the
  `msgpack_object_type` enum.

### 0.1.1 / 2010-05-21

* Fixed {FFI::MsgPack::MsgObject#initialize} on JRuby.

### 0.1.0 / 2010-05-21

* Initial release.
  * Can pack and unpack `nil`, `true`, `false`, Integers, Floats, Strings,
    Arrays and Hashes.
  * Provides a buffered / callback driven packer.
  * Provides a buffered / streaming unpacker.

