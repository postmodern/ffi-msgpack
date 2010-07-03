require 'spec_helper'
require 'ffi/msgpack/extensions/integer'

describe Integer do
  subject { 0x02 }

  it "should be packable" do
    should be_kind_of(FFI::MsgPack::Packable)
  end

  it "should pack to a msg" do
    subject.to_msgpack.should == "\x02"
  end
end
