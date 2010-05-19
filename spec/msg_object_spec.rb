require 'spec_helper'
require 'ffi/msgpack/msg_object'

describe MsgPack::MsgObject do
  describe "nil" do
    before(:all) do
      @obj = MsgPack::MsgObject.new_nil
    end

    it "should create nil Msg Objects from NilClasses" do
      obj = MsgPack::MsgObject.new_object(nil)

      obj.type.should == :nil
    end

    it "should create new nil Msg Objects" do
      @obj.type.should == :nil
    end

    it "should return a Ruby nil value" do
      @obj.to_ruby.should == nil
    end
  end

  describe "boolean" do
    before(:all) do
      @obj = MsgPack::MsgObject.new_boolean(true)
    end

    it "should create new boolean Msg Objects" do
      @obj.type.should == :boolean

      @obj[:values][:boolean].should == 1
    end

    it "should create boolean Msg Objects from TrueClass/FalseClass" do
      obj1 = MsgPack::MsgObject.new_object(true)
      obj1.type.should == :boolean

      obj2 = MsgPack::MsgObject.new_object(false)
      obj2.type.should == :boolean
    end

    it "should return a Ruby true/false value" do
      @obj.to_ruby.should == true
    end
  end

  describe "positive integer" do
    before(:all) do
      @obj = MsgPack::MsgObject.new_integer(10)
    end

    it "should create new positive integer Msg Objects" do
      @obj.type.should == :positive_integer
      @obj[:values][:u64].should == 10
    end

    it "should create positive integer Msg Objects from Integers" do
      obj1 = MsgPack::MsgObject.new_object(10)

      obj1.type.should == :positive_integer
    end

    it "should return a Ruby Integer" do
      @obj.to_ruby.should == 10
    end
  end

  describe "negative integer" do
    before(:all) do
      @obj = MsgPack::MsgObject.new_integer(-1)
    end

    it "should create new negative integer Msg Objects" do
      @obj.type.should == :negative_integer
      @obj[:values][:i64].should == -1
    end

    it "should create negative integer Msg Objects from Integers" do
      obj1 = MsgPack::MsgObject.new_object(-1)

      obj1.type.should == :negative_integer
    end

    it "should return a Ruby Integer" do
      @obj.to_ruby.should == -1
    end
  end

  describe "floating-point" do
    before(:all) do
      @obj = MsgPack::MsgObject.new_double(0.002)
    end

    it "should create new floating-point Msg Objects" do
      @obj.type.should == :double
      @obj[:values][:dec].should == 0.002
    end

    it "should create floating-point Msg Objects from Floats" do
      obj1 = MsgPack::MsgObject.new_object(0.002)

      obj1.type.should == :double
    end

    it "should return a Ruby Float" do
      @obj.to_ruby.should == 0.002
    end
  end

  describe "raw" do
    before(:all) do
      @binary = "\x01example\x0d"
      @obj = MsgPack::MsgObject.new_raw(@binary)
    end

    it "should create new raw Msg Objects" do
      @obj.type.should == :raw

      @obj[:values][:raw].length.should == @binary.length
      @obj[:values][:raw].to_s.should == @binary
    end

    it "should create raw Msg Objects from Strings" do
      obj = MsgPack::MsgObject.new_object(@binary)

      obj.type.should == :raw
    end

    it "should return a String" do
      @obj.to_ruby.should == @binary
    end
  end

  describe "array" do
    before(:all) do
      @array = [1,true,nil,0.002,'a']
      @obj = MsgPack::MsgObject.new_array(@array)
    end

    it "should create new array Msg Objects" do
      @obj.type.should == :array

      @obj[:values][:array].length.should == @array.length
    end

    it "should create raw Msg Objects from Arrays" do
      obj = MsgPack::MsgObject.new_object(@array)

      obj.type.should == :array
    end

    it "should return a Ruby Array" do
      @obj.to_ruby.should == @array
    end
  end
end
