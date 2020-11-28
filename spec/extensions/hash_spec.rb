# encoding: US-ASCII

require 'spec_helper'
require 'ffi/msgpack/extensions/hash'

describe Hash do
  subject { {1 => 'a', 2 => 'b'} }

  it "should be packable" do
    expect(subject).to be_kind_of(FFI::MsgPack::Packable)
  end

  it "should pack to a msg" do
    expect(subject.to_msgpack).to be == "\x82\x01\xA1a\x02\xA1b"
  end
end
