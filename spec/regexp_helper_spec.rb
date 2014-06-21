require 'spec_helper'

describe Orgmode::RegexpHelper do
  it "should recognize simple markup" do
    e = Orgmode::RegexpHelper.new
    total = 0
    e.match_all("/italic/") do |border, string|
      expect(border).to eql("/")
      expect(string).to eql("italic")
      total += 1
    end
    expect(total).to eql(1)

    total = 0
    borders = %w[* / ~]
    strings = %w[bold italic verbatim]
    e.match_all("This string contains *bold*, /italic/, and ~verbatim~ text.")\
    do |border, str|
      expect(border).to eql(borders[total])
      expect(str).to eql(strings[total])
      total += 1
    end
    expect(total).to eql(3)
  end

  it "should not get confused by links" do
    e = Orgmode::RegexpHelper.new
    total = 0
    # Make sure the slashes in these links aren't treated as italics
    e.match_all("[[http://www.bing.com/twitter]]") do |border, str|
      total += 1
    end
    expect(total).to eql(0)
  end

  it "should correctly perform substitutions" do
    e = Orgmode::RegexpHelper.new
    map = {
      "*" => "strong",
      "/" => "i",
      "~" => "code"
    }
    n = e.rewrite_emphasis("This string contains *bold*, /italic/, and ~verbatim~ text.") do |border, str|
      "<#{map[border]}>#{str}</#{map[border]}>"
    end
    n = e.restore_code_snippets n

    expect(n).to eql("This string contains <strong>bold</strong>, <i>italic</i>, and <code>verbatim</code> text.")
  end

  it "should allow link rewriting" do
    e = Orgmode::RegexpHelper.new
    str = e.rewrite_links("[[http://www.bing.com]]") do |link,text|
      text ||= link
      "\"#{text}\":#{link}"
    end
    expect(str).to eql("\"http://www.bing.com\":http://www.bing.com")
    str = e.rewrite_links("<http://www.google.com>") do |link|
      "\"#{link}\":#{link}"
    end
    expect(str).to eql("\"http://www.google.com\":http://www.google.com")
  end
end                             # describe Orgmode::RegexpHelper
