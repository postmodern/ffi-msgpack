require 'spec_helper'
require 'ffi/msgpack/extensions/hash'

describe Hash do
  subject { {1 => 'a', 2 => 'b'} }

  it "should be packable" do
    should be_kind_of(FFI::MsgPack::Packable)
  end

  it "should pack to a msg" do
    pending "fix packing of Hashes" do
      subject.to_msgpack.should == "\x92\x01\x02"
    end
  end
end
