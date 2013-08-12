# encoding: US-ASCII

require 'spec_helper'
require 'ffi/msgpack/extensions/symbol'

describe Symbol do
  subject { :hello }

  it "should be packable" do
    should be_kind_of(FFI::MsgPack::Packable)
  end

  it "should pack to a msg" do
    subject.to_msgpack.should == "\xA5hello"
  end
end
