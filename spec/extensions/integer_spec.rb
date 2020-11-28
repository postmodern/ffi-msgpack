require 'spec_helper'
require 'ffi/msgpack/extensions/integer'

describe Integer do
  subject { 0x02 }

  it "should be packable" do
    should be_kind_of(FFI::MsgPack::Packable)
  end

  it "should pack to a msg" do
    expect(subject.to_msgpack).to eq("\x02")
  end
end
