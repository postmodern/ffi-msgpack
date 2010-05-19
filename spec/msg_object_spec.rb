require 'spec_helper'
require 'ffi/msgpack/msg_object'

describe MsgPack::MsgObject do
  describe "nil" do
    before(:all) do
      @obj = MsgPack::MsgObject.new_nil
    end

    it "should create new nil Msg Objects" do
      @obj.type.should == :nil
    end

    it "should return a Ruby nil value" do
      @obj.value.should == nil
    end
  end

  describe "boolean" do
    before(:all) do
      @obj = MsgPack::MsgObject.new_boolean(true)
    end

    it "should create new boolean Msg Objects" do
      @obj.type.should == :boolean

      @obj.values[:boolean].should == 1
    end

    it "should return a Ruby true/false value" do
      @obj.value.should == true
    end
  end

  describe "positive integer" do
    before(:all) do
      @obj = MsgPack::MsgObject.new_integer(10)
    end

    it "should create new positive integer Msg Objects" do
      @obj.type.should == :positive_integer
      @obj.values[:u64].should == 10
    end

    it "should return a Ruby Integer" do
      @obj.value.should == 10
    end
  end

  describe "negative integer" do
    before(:all) do
      @obj = MsgPack::MsgObject.new_integer(-1)
    end

    it "should create new negative integer Msg Objects" do
      @obj.type.should == :negative_integer
      @obj.values[:i64].should == -1
    end

    it "should return a Ruby Integer" do
      @obj.value.should == -1
    end
  end

  describe "floating-point" do
    before(:all) do
      @obj = MsgPack::MsgObject.new_double(0.002)
    end

    it "should create new floating-point Msg Objects" do
      @obj.type.should == :double
      @obj.values[:dec].should == 0.002
    end

    it "should return a Ruby Float" do
      @obj.value.should == 0.002
    end
  end
end
