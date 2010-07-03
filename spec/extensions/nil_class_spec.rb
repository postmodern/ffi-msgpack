require 'spec_helper'
require 'ffi/msgpack/extensions/nil_class'

describe NilClass do
  subject { nil }

  it "should be packable" do
    should be_kind_of(FFI::MsgPack::Packable)
  end

  it "should pack to a msg" do
    subject.to_msgpack.should == "\xC0"
  end
end
