require "json"
require "./spec_helper"

# Examples taken from node-jsonpointer
input1 = JSON.parse(
  <<-JSON
  {
    "a": 1,
    "b": {
      "c": 2
    },
    "d": {
      "e": [{ "a": 3 }, { "b": 4 }, { "c": 5 }]
    }
  }
  JSON
)

input2 = JSON.parse(
  <<-JSON
  {
    "a/b": {
      "c": 1
    },
    "d": {
      "e/f": 2
    },
    "~1": 3,
    "01": 4
  }
  JSON
)

# These are the bonkers examples from the RFC, some of which are just plain
# annoying that they work (for example empty string and space - numbers 0 and 6)
input3 = JSON.parse(
  <<-JSON
  {
    "foo": ["bar", "baz"],
    "": 0,
    "a/b": 1,
    "c%d": 2,
    "e^f": 3,
    "g|h": 4,
    "k'l": 5,
    " ": 6,
    "m~n": 7
  }
  JSON
)

describe JSONPointer do
  it "handles input1" do
    JSONPointer.from("/a").get(input1).should eq(1)
    JSONPointer.from("/b/c").get(input1).should eq(2)
    JSONPointer.from("/d/e/0/a").get(input1).should eq(3)
    JSONPointer.from("/d/e/1/b").get(input1).should eq(4)
    JSONPointer.from("/d/e/2/c").get(input1).should eq(5)
  end

  it "handles input2" do
    JSONPointer.from("/a~1b/c").get(input2).should eq(1)
    JSONPointer.from("/d/e~1f").get(input2).should eq(2)
    JSONPointer.from("/~01").get(input2).should eq(3)
    JSONPointer.from("/01").get(input2).should eq(4)
    JSONPointer.from("/a/b/c").get?(input2).should be_nil
    JSONPointer.from("/~1").get?(input2).should be_nil
  end

  it "handles input3" do
    JSONPointer.from("").get(input3).should eq(input3)
    JSONPointer.from("/foo").get(input3).should eq(["bar", "baz"])
    JSONPointer.from("/foo/0").get(input3).should eq("bar")
    JSONPointer.from("/").get(input3).should eq(0)
    JSONPointer.from("/a~1b").get(input3).should eq(1)
    JSONPointer.from("/c%d").get(input3).should eq(2)
    JSONPointer.from("/e^f").get(input3).should eq(3)
    JSONPointer.from("/g|h").get(input3).should eq(4)
    JSONPointer.from("/k'l").get(input3).should eq(5)
    JSONPointer.from("/ ").get(input3).should eq(6)
    JSONPointer.from("/m~0n").get(input3).should eq(7)
  end
end
