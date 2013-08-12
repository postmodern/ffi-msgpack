# encoding: US-ASCII

require 'spec_helper'
require 'ffi/msgpack/extensions/true_class'

describe TrueClass do
  subject { true }

  it "should be packable" do
    should be_kind_of(FFI::MsgPack::Packable)
  end

  it "should pack to a msg" do
    subject.to_msgpack.should == "\xC3"
  end
end
