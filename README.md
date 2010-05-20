# ffi-msgpack

* [github.com/postmodern/ffi-msgpack](http://github.com/postmodern/ffi-msgpack/)
* [github.com/postmodern/ffi-msgpack/issues](http://github.com/postmodern/ffi-msgpack/issues)
* Postmodern (postmodern.mod3 at gmail.com)

## Description

Ruby FFI bindings for the [msgpack](http://msgpack.sourceforge.net/) library.

## Features

## Examples

Pack an Object:

    require 'ffi/msgpack'

    FFI::MsgPack.pack([1,'x',true])
    # => "\x93\x01\xA1x\xC3"

Pack one or more Objects into a Buffer:

    packer = FFI::MsgPack::Packer.create
    packer << 1
    packer << 'x'
    packer << true

    packer.buffer
    # => "\x01\xA1x\xC3"
    packer.total
    # => 3

Pack one or more Objects with a custom write callback:

    require 'socket'

    socket = TCPSocket.new('example.com',9786)
    packer = FFI::MsgPack::Packer.create do |packed,length|
      socket.write(packed)
    end

    packer << 1
    packer << 'x'
    packer << true
    socket.close

    packer.total
    # => 3

Unpack a String:

    FFI::MsgPack.unpack("\x93\x01\xA1x\xC3")
    # => [1, "x", true]

Enumerate over each unpacked Object:

    unpacker = FFI::MsgPack::Unpacker.create
    unpacker << "\x01\xA1x\xC3"

    unpacker.each do |obj|
      puts obj.inspect
    end

## Requirements

* [msgpack](http://msgpack.sourceforge.net/) >= 0.4.2
* [ffi](http://github.com/ffi/ffi) >= 0.6.0

## Install

    $ sudo gem install ffi-msgpack

## License

See {file:LICENSE.txt} for license information.

