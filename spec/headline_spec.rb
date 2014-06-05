require 'spec_helper'

describe Orgmode::Headline do

  it "should recognize headlines that start with asterisks" do
    expect(Orgmode::Headline.headline?("*** test\n")).to be_truthy
  end

  it "should reject headlines without headlines at the start" do
    expect(Orgmode::Headline.headline?("  nope!")).to be_nil
    expect(Orgmode::Headline.headline?("  tricked you!!!***")).to be_nil
  end

  it "should reject improper initialization" do
    lambda { Orgmode::Headline.new " tricked**" }.should raise_error
  end

  it "should properly determine headline level" do
    samples = ["* one", "** two", "*** three", "**** four"]
    expected = 1
    samples.each do |sample|
      h = Orgmode::Headline.new sample
      h.level.should eql(expected)
      expected += 1
    end
  end

  it "should properly determine headline level with offset" do
    h = Orgmode::Headline.new("* one", nil, 1)
    h.level.should eql(2)
  end

  it "should find simple headline text" do
    h = Orgmode::Headline.new "*** sample"
    h.headline_text.should eql("sample")
  end

  it "should understand tags" do
    h = Orgmode::Headline.new "*** sample :tag:tag2:\n"
    h.headline_text.should eql("sample")
    expect(h.tags.count).to eq(2)
    h.tags[0].should eql("tag")
    h.tags[1].should eql("tag2")
  end

  it "should understand a single tag" do
    h = Orgmode::Headline.new "*** sample :tag:\n"
    h.headline_text.should eql("sample")
    expect(h.tags.count).to eq(1)
    h.tags[0].should eql("tag")
  end

  it "should understand keywords" do
    h = Orgmode::Headline.new "*** TODO Feed cat  :home:"
    h.headline_text.should eql("Feed cat")
    h.keyword.should eql("TODO")
  end

  it "should recognize headlines marked as COMMENT" do
    h = Orgmode::Headline.new "* COMMENT This headline is a comment"
    h.comment_headline?.should_not be_nil
  end
end

