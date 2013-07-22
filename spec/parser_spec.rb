require 'spec_helper'

describe Orgmode::Parser do
  it "should open ORG files" do
    parser = Orgmode::Parser.load(RememberFile)
  end

  it "should fail on non-existant files" do
    lambda { parser = Orgmode::Parser.load("does-not-exist.org") }.should raise_error
  end

  it "should load all of the lines" do
    parser = Orgmode::Parser.load(RememberFile)
    parser.lines.length.should eql(53)
  end

  it "should find all headlines" do
    parser = Orgmode::Parser.load(RememberFile)
    parser.should have(12).headlines
  end

  it "can find a headline by index" do
    parser = Orgmode::Parser.load(RememberFile)
    line = parser.headlines[1].to_s
    line.should eql("** YAML header in Webby\n")
  end

  it "should determine headline levels" do
    parser = Orgmode::Parser.load(RememberFile)
    parser.headlines[0].level.should eql(1)
    parser.headlines[1].level.should eql(2)
  end

  it "should include the property drawer items from a headline" do
    parser = Orgmode::Parser.load(FreeformExampleFile)
    parser.headlines.first.property_drawer.count.should == 2
    parser.headlines.first.property_drawer['DATE'].should == '2009-11-26'
    parser.headlines.first.property_drawer['SLUG'].should == 'future-ideas'
  end

  it "should put body lines in headlines" do
    parser = Orgmode::Parser.load(RememberFile)
    parser.headlines[0].should have(1).body_lines
    parser.headlines[1].should have(7).body_lines
  end

  it "should understand lines before the first headline" do
    parser = Orgmode::Parser.load(FreeformFile)
    parser.should have(19).header_lines
  end

  it "should load in-buffer settings" do
    parser = Orgmode::Parser.load(FreeformFile)
    parser.should have(12).in_buffer_settings
    parser.in_buffer_settings["TITLE"].should eql("Freeform")
    parser.in_buffer_settings["EMAIL"].should eql("bdewey@gmail.com")
    parser.in_buffer_settings["LANGUAGE"].should eql("en")
  end

  it "should understand OPTIONS" do
    parser = Orgmode::Parser.load(FreeformFile)
    parser.should have(19).options
    parser.options["TeX"].should eql("t")
    parser.options["todo"].should eql("t")
    parser.options["\\n"].should eql("nil")
    parser.export_todo?.should be_true
    parser.options.delete("todo")
    parser.export_todo?.should be_false
  end

  it "should skip in-buffer settings inside EXAMPLE blocks" do
    parser = Orgmode::Parser.load(FreeformExampleFile)
    parser.should have(0).in_buffer_settings
  end

  it "should return a textile string" do
    parser = Orgmode::Parser.load(FreeformFile)
    parser.to_textile.should be_kind_of(String)
  end

  it "should understand export table option" do
    fname = File.join(File.dirname(__FILE__), %w[html_examples skip-table.org])
    data = IO.read(fname)
    p = Orgmode::Parser.new(data)
    p.export_tables?.should be_false
  end

  context "with a table that begins with a separator line" do
    let(:parser) { Orgmode::Parser.new(data) }
    let(:data) { Pathname.new(File.dirname(__FILE__)).join('data', 'tables.org').read }

    it "should parse without errors" do
      parser.headlines.size.should == 2
    end
  end

  describe "Custom keyword parser" do
    fname = File.join(File.dirname(__FILE__), %w[html_examples custom-todo.org])
    p = Orgmode::Parser.load(fname)
    valid_keywords = %w[TODO INPROGRESS WAITING DONE CANCELED]
    invalid_keywords = %w[TODOX todo inprogress Waiting done cANCELED NEXT |]
    valid_keywords.each do |kw|
      it "should match custom keyword #{kw}" do
        (kw =~ p.custom_keyword_regexp).should be_true
      end
    end
    invalid_keywords.each do |kw|
      it "should not match custom keyword #{kw}" do
        (kw =~ p.custom_keyword_regexp).should be_nil
      end
    end
    it "should not match blank as a custom keyword" do
      ("" =~ p.custom_keyword_regexp).should be_nil
    end
  end

  describe "Custom include/exclude parser" do
    fname = File.join(File.dirname(__FILE__), %w[html_examples export-tags.org])
    p = Orgmode::Parser.load(fname)
    it "should load tags" do
      p.should have(2).export_exclude_tags
      p.should have(1).export_select_tags
    end
  end

  describe "Export to Textile test cases" do
    data_directory = File.join(File.dirname(__FILE__), "textile_examples")
    org_files = File.expand_path(File.join(data_directory, "*.org" ))
    files = Dir.glob(org_files)
    files.each do |file|
      basename = File.basename(file, ".org")
      textile_name = File.join(data_directory, basename + ".textile")
      textile_name = File.expand_path(textile_name)

      it "should convert #{basename}.org to Textile" do
        expected = IO.read(textile_name)
        expected.should be_kind_of(String)
        parser = Orgmode::Parser.new(IO.read(file))
        actual = parser.to_textile
        actual.should be_kind_of(String)
        actual.should == expected
      end
    end
  end

  describe "Export to HTML test cases" do
    # Dynamic generation of examples from each *.org file in html_examples.
    # Each of these files is convertable to HTML.
    data_directory = File.join(File.dirname(__FILE__), "html_examples")
    org_files = File.expand_path(File.join(data_directory, "*.org" ))
    files = Dir.glob(org_files)
    files.each do |file|
      basename = File.basename(file, ".org")
      textile_name = File.join(data_directory, basename + ".html")
      textile_name = File.expand_path(textile_name)

      it "should convert #{basename}.org to HTML" do
        expected = IO.read(textile_name)
        expected.should be_kind_of(String)
        parser = Orgmode::Parser.new(IO.read(file))
        actual = parser.to_html
        actual.should be_kind_of(String)
        actual.should == expected
      end

      it "should render #{basename}.org to HTML using Tilt templates" do
        expected = IO.read(textile_name)
        template = Tilt.new(file).render
        template.should == expected
      end
    end
  end

  describe "Export to HTML test cases with code syntax highlight" do
    code_syntax_examples_directory = File.join(File.dirname(__FILE__), "html_code_syntax_highlight_examples")

    # Include the code syntax highlight support tests
    if defined? CodeRay
      # Use CodeRay for syntax highlight (pure Ruby solution)
      org_files = File.expand_path(File.join(code_syntax_examples_directory, "*-coderay.org"))
    elsif defined? Pygments
      # Use pygments (so that it works with Jekyll, Gollum and possibly Github)
      org_files = File.expand_path(File.join(code_syntax_examples_directory, "*-pygments.org"))
    else
      # Do not use syntax coloring for source code blocks
      org_files = File.expand_path(File.join(code_syntax_examples_directory, "*-no-color.org"))
    end
    files = Dir.glob(org_files)

    files.each do |file|
      basename = File.basename(file, ".org")
      textile_name = File.join(code_syntax_examples_directory, basename + ".html")
      textile_name = File.expand_path(textile_name)

      it "should convert #{basename}.org to HTML" do
        expected = IO.read(textile_name)
        expected.should be_kind_of(String)
        parser = Orgmode::Parser.new(IO.read(file))
        actual = parser.to_html
        actual.should be_kind_of(String)
        actual.should == expected
      end

      it "should render #{basename}.org to HTML using Tilt templates" do
        expected = IO.read(textile_name)
        template = Tilt.new(file).render
        template.should == expected
      end
    end
  end

  describe "Org to Org export" do
    ORG_TO_ORG_EXAMPLES_DIR = File.join(File.dirname(__FILE__), "org_to_org_examples")

    it "should be possible to export to Org again" do
      content = File.open("#{ORG_TO_ORG_EXAMPLES_DIR}/basic.org").read
      org = Orgmode::Parser.new(content).to_org
      org.should_not be_empty
    end

    it "should be possible to inject properties to parsed Org content" do
      content = File.open("#{ORG_TO_ORG_EXAMPLES_DIR}/property-injection.org").read
      org = Orgmode::Parser.new(content)
      org.headlines.count.should == 3
      property_drawer = org.headlines.first.property_drawer
      property_drawer['ID'] = 'YXNkZml1aGFzZGlhc2lkZmg'
      property_drawer['SLUG'] = 'load-this-headline-and-then-export-it-back'
      result = org.to_org
      result.should_not be_empty
      expected_result = File.open("#{ORG_TO_ORG_EXAMPLES_DIR}/property-injection-result.org").read
      expected_result << "\n"
      expected_result.should == result
    end
  end
end

