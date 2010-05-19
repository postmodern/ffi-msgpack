require 'spec_helper'
require 'ffi/msgpack/msg_object'

describe MsgPack::MsgObject do
  it "should create new nil Msg Objects" do
    obj = MsgPack::MsgObject.new_nil

    obj.type.should == :nil
  end

  it "should create new boolean Msg Objects" do
    obj = MsgPack::MsgObject.new_boolean(true)
    obj.type.should == :boolean

    obj.values[:boolean].should == 1
  end

  it "should create new positive integer Msg Objects" do
    obj = MsgPack::MsgObject.new_integer(10)

    obj.type.should == :positive_integer
    obj.values[:u64].should == 10
  end

  it "should create new negative integer Msg Objects" do
    obj = MsgPack::MsgObject.new_integer(-1)

    obj.type.should == :negative_integer
    obj.values[:i64].should == -1
  end

  it "should create new floating-point Msg Objects" do
    obj = MsgPack::MsgObject.new_double(0.002)

    obj.type.should == :double
    obj.values[:dec].should == 0.002
  end
end
