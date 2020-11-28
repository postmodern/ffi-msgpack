require 'spec_helper'
require 'ffi/msgpack/msg_object'

describe MsgPack::MsgObject do
  describe "nil" do
    before(:all) do
      @obj = MsgPack::MsgObject.new_nil
    end

    it "should create nil Msg Objects from NilClasses" do
      obj = MsgPack::MsgObject.new_object(nil)

      expect(obj.type).to eq(:nil)
    end

    it "should create new nil Msg Objects" do
      expect(@obj.type).to eq(:nil)
    end

    it "should return a Ruby nil value" do
      expect(@obj.to_ruby).to eq(nil)
    end
  end

  describe "boolean" do
    before(:all) do
      @obj = MsgPack::MsgObject.new_boolean(true)
    end

    it "should create new boolean Msg Objects" do
      expect(@obj.type).to eq(:boolean)

      expect(@obj[:values][:boolean]).to eq(1)
    end

    it "should create boolean Msg Objects from TrueClass/FalseClass" do
      obj1 = MsgPack::MsgObject.new_object(true)
      expect(obj1.type).to eq(:boolean)

      obj2 = MsgPack::MsgObject.new_object(false)
      expect(obj2.type).to eq(:boolean)
    end

    it "should return a Ruby true/false value" do
      expect(@obj.to_ruby).to eq(true)
    end
  end

  describe "positive integer" do
    before(:all) do
      @obj = MsgPack::MsgObject.new_integer(10)
    end

    it "should create new positive integer Msg Objects" do
      expect(@obj.type).to eq(:positive_integer)
      expect(@obj[:values][:u64]).to eq(10)
    end

    it "should create positive integer Msg Objects from Integers" do
      obj1 = MsgPack::MsgObject.new_object(10)

      expect(obj1.type).to eq(:positive_integer)
    end

    it "should return a Ruby Integer" do
      expect(@obj.to_ruby).to eq(10)
    end
  end

  describe "negative integer" do
    before(:all) do
      @obj = MsgPack::MsgObject.new_integer(-1)
    end

    it "should create new negative integer Msg Objects" do
      expect(@obj.type).to eq(:negative_integer)
      expect(@obj[:values][:i64]).to eq(-1)
    end

    it "should create negative integer Msg Objects from Integers" do
      obj1 = MsgPack::MsgObject.new_object(-1)

      expect(obj1.type).to eq(:negative_integer)
    end

    it "should return a Ruby Integer" do
      expect(@obj.to_ruby).to eq(-1)
    end
  end

  describe "floating-point" do
    before(:all) do
      @obj = MsgPack::MsgObject.new_double(0.002)
    end

    it "should create new floating-point Msg Objects" do
      expect(@obj.type).to eq(:double)
      expect(@obj[:values][:dec]).to eq(0.002)
    end

    it "should create floating-point Msg Objects from Floats" do
      obj1 = MsgPack::MsgObject.new_object(0.002)

      expect(obj1.type).to eq(:double)
    end

    it "should return a Ruby Float" do
      expect(@obj.to_ruby).to eq(0.002)
    end
  end

  describe "raw" do
    before(:all) do
      @binary = "\x01example\x0d"
      @obj = MsgPack::MsgObject.new_raw(@binary)
    end

    it "should create new raw Msg Objects" do
      expect(@obj.type).to eq(:raw)

      expect(@obj[:values][:raw].length).to eq(@binary.length)
      expect(@obj[:values][:raw].to_s).to eq(@binary)
    end

    it "should create raw Msg Objects from Strings" do
      obj = MsgPack::MsgObject.new_object(@binary)

      expect(obj.type).to eq(:raw)
    end

    it "should create raw Msg Objects from Symbols" do
      obj = MsgPack::MsgObject.new_object(:example)

      expect(obj.type).to eq(:raw)
    end

    it "should return a String" do
      expect(@obj.to_ruby).to eq(@binary)
    end
  end

  describe "array" do
    before(:all) do
      @array = [1,true,nil,0.002,'a']
      @obj = MsgPack::MsgObject.new_array(@array)
    end

    it "should create new array Msg Objects" do
      expect(@obj.type).to eq(:array)

      expect(@obj[:values][:array].length).to eq(@array.length)
    end

    it "should create array Msg Objects from Arrays" do
      obj = MsgPack::MsgObject.new_object(@array)

      expect(obj.type).to eq(:array)
    end

    it "should return a Ruby Array" do
      expect(@obj.to_ruby).to eq(@array)
    end
  end

  describe "map" do
    before(:all) do
      @hash = {
        1 => 2,
        0.001 => 0.002,
        nil => nil,
        true => false,
        'a' => 'b'
      }
      @obj = MsgPack::MsgObject.new_map(@hash)
    end

    it "should create new map Msg Objects" do
      expect(@obj.type).to eq(:map)

      expect(@obj[:values][:map].length).to eq(@hash.length)
    end

    it "should create map Msg Objects from Hashes" do
      obj = MsgPack::MsgObject.new_object(@hash)

      expect(obj.type).to eq(:map)
    end

    it "should return a Ruby Hash" do
      expect(@obj.to_ruby).to eq(@hash)
    end
  end

  it "should create highly nested Msg Objects" do
    obj = MsgPack::MsgObject.new_object({'one' => {2 => [3.0]}})

    expect(obj[:type]).to eq(:map)
    map = obj[:values][:map]
    expect(map[:size]).to eq(1)

    pair = MsgPack::MsgKeyValue.new(map[:ptr])

    key = pair[:key]
    expect(key[:type]).to eq(:raw)

    raw = key[:values][:raw]
    expect(raw[:ptr].read_bytes(raw[:size])).to eq('one')

    value = pair[:value]
    expect(value[:type]).to eq(:map)

    map = value[:values][:map]
    expect(map[:size]).to eq(1)

    pair = MsgPack::MsgKeyValue.new(map[:ptr])
    key = pair[:key]
    expect(key[:type]).to eq(:positive_integer)
    expect(key[:values][:i64]).to eq(2)

    value = pair[:value]
    expect(value[:type]).to eq(:array)

    array = value[:values][:array]
    expect(array[:size]).to eq(1)

    value = MsgPack::MsgObject.new(array[:ptr])
    expect(value[:type]).to eq(:double)
    expect(value[:values][:dec]).to eq(3.0)
  end
end
