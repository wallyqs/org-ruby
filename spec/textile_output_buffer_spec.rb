require 'spec_helper'

describe Orgmode::TextileOutputBuffer do
  it "should substitute / with _" do
    expect(Orgmode::TextileOutputBuffer.new("").inline_formatting("/italic/")).to eql("_italic_")
  end

  it "should convert simple links" do
    expect(Orgmode::TextileOutputBuffer.new("").inline_formatting("[[http://www.google.com]]")).to \
      eql("\"http://www.google.com\":http://www.google.com")
  end

  it "should convert links with text" do
    expect(Orgmode::TextileOutputBuffer.new("").inline_formatting("[[http://www.google.com][Google]]")).to \
      eql("\"Google\":http://www.google.com")
  end

  it "should convert spaces in urls" do
    expect(Orgmode::TextileOutputBuffer.new("").inline_formatting("[[my url]]")).to eql("\"my url\":my%20url")
  end
end
