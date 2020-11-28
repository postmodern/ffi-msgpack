# encoding: US-ASCII

require 'spec_helper'
require 'ffi/msgpack/extensions/symbol'

describe Symbol do
  subject { :hello }

  it "should be packable" do
    expect(subject).to be_kind_of(FFI::MsgPack::Packable)
  end

  it "should pack to a msg" do
    expect(subject.to_msgpack).to be == "\xA5hello"
  end
end
