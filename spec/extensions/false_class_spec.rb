# encoding: US-ASCII

require 'spec_helper'
require 'ffi/msgpack/extensions/false_class'

describe FalseClass do
  subject { false }

  it "should be packable" do
    expect(subject).to be_kind_of(FFI::MsgPack::Packable)
  end

  it "should pack to a msg" do
    expect(subject.to_msgpack).to be == "\xC2"
  end
end
