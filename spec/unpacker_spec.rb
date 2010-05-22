require 'spec_helper'
require 'ffi/msgpack/unpacker'

require 'stringio'

describe MsgPack::Unpacker do
  before(:all) do
    @packed = "\x01\x02\x03"
  end

  before(:each) do
    @unpacker = MsgPack::Unpacker.create(1024)
  end

  describe "buffer" do
    it "should enqueue data into the buffer" do
      size1 = @unpacker[:used]
      @unpacker << @packed
      size2 = @unpacker[:used]

      (size2 - size1).should == @packed.length
    end

    it "should enqueue data from IO objects into the buffer" do
      io = StringIO.new(@packed)

      size1 = @unpacker[:used]
      @unpacker.read(io).should == true
      size2 = @unpacker[:used]

      (size2 - size1).should == @packed.length
    end
  end

  describe "each_object" do
    it "should unpack each Msg Object from the buffer" do
      objs = []
      expected = [
        [:positive_integer, 1],
        [:positive_integer, 2],
        [:positive_integer, 3]
      ]

      @unpacker << @packed
      @unpacker.each_object do |obj|
        objs << [obj.type, obj.values[:u64]]
      end

      objs.should == expected
    end

    it "should unpack each Msg Object from a stream" do
      io = StringIO.new(@packed)
      objs = []
      expected = [
        [:positive_integer, 1],
        [:positive_integer, 2],
        [:positive_integer, 3]
      ]

      @unpacker.stream = io
      @unpacker.each_object do |obj|
        objs << [obj.type, obj.values[:u64]]
      end

      objs.should == expected
    end
  end
end
