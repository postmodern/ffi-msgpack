require 'spec_helper'
require 'ffi/msgpack/packer'

describe MsgPack::Packer do
  context "buffer" do
    before(:each) do
      @packer = MsgPack::Packer.create
      @packer << 1
    end

    it "should write packed messages to a buffer" do
      @packer.buffer.should == "\x01"
    end

    it "should track the number of bytes written" do
      @packer.length.should == 1
    end

    it "should be convertable to a String" do
      @packer.to_s.should == "\x01"
    end
  end

  context "callback" do
    before(:each) do
      @buffer = []
    end

    it "should write packed messages using a callback" do
      packer = MsgPack::Packer.create do |packed|
        @buffer << packed
      end
      packer << 1

      @buffer.should == ["\x01"]
    end

    it "should track the number of bytes written" do
      packer = MsgPack::Packer.create do |packed|
        @buffer << packed
      end
      packer << 1

      packer.length.should == 1
    end

    it "should accept a secondary length argument" do
      packer = MsgPack::Packer.create do |packed,length|
        @buffer << [packed, length]
      end
      packer << 1

      @buffer.should == [["\x01", 1]]
    end

    it "should not be convertable to a String" do
      packer = MsgPack::Packer.create { |packed| }

      packer.to_s.should == nil
    end
  end
end
