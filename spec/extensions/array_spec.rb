require 'spec_helper'
require 'ffi/msgpack/extensions/array'

describe Array do
  subject { [1, 2] }

  it "should be packable" do
    should be_kind_of(FFI::MsgPack::Packable)
  end

  it "should pack to a msg" do
    subject.to_msgpack.should == "\x92\x01\x02"
  end
end
