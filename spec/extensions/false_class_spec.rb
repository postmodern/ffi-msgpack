# encoding: US-ASCII

require 'spec_helper'
require 'ffi/msgpack/extensions/false_class'

describe FalseClass do
  subject { false }

  it "should be packable" do
    should be_kind_of(FFI::MsgPack::Packable)
  end

  it "should pack to a msg" do
    subject.to_msgpack.should == "\xC2"
  end
end
