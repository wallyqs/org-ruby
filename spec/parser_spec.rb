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

  it "should add code block name as a line property" do
    example = <<EXAMPLE
* Sample

#+name: hello_world
#+begin_src sh :results output
echo 'hello world'
#+end_src
EXAMPLE
    o = Orgmode::Parser.new(example)
    h = o.headlines.first
    line = h.body_lines.find { |l| l.to_s == "#+begin_src sh :results output"}
    line.properties['block_name'].should == 'hello_world'
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
        parser = Orgmode::Parser.new(IO.read(file), { :allow_include_files => true })
        actual = parser.to_html
        actual.should be_kind_of(String)
        actual.should == expected
      end

      it "should render #{basename}.org to HTML using Tilt templates" do
        ENV['ORG_RUBY_ENABLE_INCLUDE_FILES'] = 'true'
        expected = IO.read(textile_name)
        template = Tilt.new(file).render
        template.should == expected
        ENV['ORG_RUBY_ENABLE_INCLUDE_FILES'] = ''
      end
    end

    it "should not render #+INCLUDE directive when explicitly indicated" do
      data_directory = File.join(File.dirname(__FILE__), "html_examples")
      expected = File.read(File.join(data_directory, "include-file-disabled.html"))
      org_file = File.join(data_directory, "include-file.org")
      parser = Orgmode::Parser.new(IO.read(org_file), :allow_include_files => false)
      actual = parser.to_html
      actual.should == expected
    end

    it "should render #+INCLUDE when ORG_RUBY_INCLUDE_ROOT is set" do
      data_directory = File.expand_path(File.join(File.dirname(__FILE__), "html_examples"))
      ENV['ORG_RUBY_INCLUDE_ROOT'] = data_directory
      expected = File.read(File.join(data_directory, "include-file.html"))
      org_file = File.join(data_directory, "include-file.org")
      parser = Orgmode::Parser.new(IO.read(org_file))
      actual = parser.to_html
      actual.should == expected
      ENV['ORG_RUBY_INCLUDE_ROOT'] = nil
    end
  end

  describe "Export to HTML test cases with code syntax highlight disabled" do
    code_syntax_examples_directory = File.join(File.dirname(__FILE__), "html_code_syntax_highlight_examples")

    # Do not use syntax coloring for source code blocks
    org_files = File.expand_path(File.join(code_syntax_examples_directory, "*-no-color.org"))
    files = Dir.glob(org_files)

    files.each do |file|
      basename = File.basename(file, ".org")
      org_filename = File.join(code_syntax_examples_directory, basename + ".html")
      org_filename = File.expand_path(org_filename)

      it "should convert #{basename}.org to HTML" do
        expected = IO.read(org_filename)
        expected.should be_kind_of(String)
        parser = Orgmode::Parser.new(IO.read(file), {
                                       :allow_include_files   => true,
                                       :skip_syntax_highlight => true
                                     })
        actual = parser.to_html
        actual.should be_kind_of(String)
        actual.should == expected
      end

      it "should render #{basename}.org to HTML using Tilt templates",
      :if => (defined? Coderay or defined? Pygments) do
        ENV['ORG_RUBY_ENABLE_INCLUDE_FILES'] = 'true'
        expected = IO.read(org_filename)
        template = Tilt.new(file).render
        template.should == expected
        ENV['ORG_RUBY_ENABLE_INCLUDE_FILES'] = ''
      end
    end
  end

  ['coderay', 'pygments'].each do |highlighter|
    if defined? (instance_eval highlighter.capitalize)
      describe "Export to HTML test cases with code syntax highlight: #{highlighter}" do
        code_syntax_examples_directory = File.join(File.dirname(__FILE__), "html_code_syntax_highlight_examples")
        files = []

        # Either Pygments or Coderay
        begin
          require highlighter
        rescue LoadError
          next
        end

        org_files = File.expand_path(File.join(code_syntax_examples_directory, "*-#{highlighter}.org"))
        files = Dir.glob(org_files)

        files.each do |file|
          basename = File.basename(file, ".org")
          org_filename = File.join(code_syntax_examples_directory, basename + ".html")
          org_filename = File.expand_path(org_filename)

          it "should convert #{basename}.org to HTML" do
            expected = IO.read(org_filename)
            expected.should be_kind_of(String)
            parser = Orgmode::Parser.new(IO.read(file), :allow_include_files => true)
            actual = parser.to_html
            actual.should be_kind_of(String)
            actual.should == expected
          end

          it "should render #{basename}.org to HTML using Tilt templates" do
            ENV['ORG_RUBY_ENABLE_INCLUDE_FILES'] = 'true'
            expected = IO.read(org_filename)
            template = Tilt.new(file).render
            template.should == expected
            ENV['ORG_RUBY_ENABLE_INCLUDE_FILES'] = ''
          end
        end
      end
    end
  end

  describe "Export to Markdown test cases" do
    data_directory = File.join(File.dirname(__FILE__), "markdown_examples")
    org_files = File.expand_path(File.join(data_directory, "*.org" ))
    files = Dir.glob(org_files)
    files.each do |file|
      basename = File.basename(file, ".org")
      markdown_name = File.join(data_directory, basename + ".md")
      markdown_name = File.expand_path(markdown_name)

      it "should convert #{basename}.org to Markdown" do
        expected = IO.read(markdown_name)
        expected.should be_kind_of(String)
        parser = Orgmode::Parser.new(IO.read(file), :allow_include_files => false)
        actual = parser.to_markdown
        actual.should be_kind_of(String)
        actual.should == expected
      end
    end
  end

  describe "Export to Markdown with incorrect custom markup test cases" do
    # The following tests export Markdown to the default markup of org-ruby
    # since the YAML file only contains the incorrect keys
    data_directory = File.join(File.dirname(__FILE__), "markdown_with_custom_markup_examples")
    org_files = File.expand_path(File.join(data_directory, "*.org" ))
    files = Dir.glob(org_files)
    files.each do |file|
      basename = File.basename(file, ".org")
      default_html_name = File.join(data_directory, basename + "_default.md")
      default_html_name = File.expand_path(default_html_name)
      custom_markup_file = File.join(data_directory, "incorrect_markup_for_markdown.yml")
      custom_markup_file = File.expand_path(custom_markup_file)

      it "should convert #{basename}.org to Markdown with the default markup" do
        expected = IO.read(default_html_name)
        expected.should be_kind_of(String)
        parser = Orgmode::Parser.new(IO.read(file), { :allow_include_files => true, :markup_file => custom_markup_file })
        actual = parser.to_markdown
        actual.should be_kind_of(String)
        actual.should == expected
      end
    end
  end

  describe "Export to Markdown with missing custom markup file test cases" do
    # The following tests export Markdown to the default markup of org-ruby
    # since the YAML file only contains the incorrect keys
    data_directory = File.join(File.dirname(__FILE__), "markdown_with_custom_markup_examples")
    org_files = File.expand_path(File.join(data_directory, "*.org" ))
    files = Dir.glob(org_files)
    files.each do |file|
      basename = File.basename(file, ".org")
      default_html_name = File.join(data_directory, basename + "_default.md")
      default_html_name = File.expand_path(default_html_name)
      custom_markup_file = File.join(data_directory, "this_file_does_not_exists.yml")
      custom_markup_file = File.expand_path(custom_markup_file)

      it "should convert #{basename}.org to Markdown with the default markup" do
        expected = IO.read(default_html_name)
        expected.should be_kind_of(String)
        parser = Orgmode::Parser.new(IO.read(file), { :allow_include_files => true, :markup_file => custom_markup_file })
        actual = parser.to_markdown
        actual.should be_kind_of(String)
        actual.should == expected
      end
    end
  end

  describe "Export to Markdown with custom markup test cases" do
    data_directory = File.join(File.dirname(__FILE__), "markdown_with_custom_markup_examples")
    org_files = File.expand_path(File.join(data_directory, "*.org" ))
    files = Dir.glob(org_files)
    files.each do |file|
      basename = File.basename(file, ".org")
      markdown_name = File.join(data_directory, basename + ".md")
      markdown_name = File.expand_path(markdown_name)
      custom_markup_file = File.join(data_directory, "custom_markup_for_markdown.yml")
      custom_markup_file = File.expand_path(custom_markup_file)

      it "should convert #{basename}.org to Markdown with custom markup" do
        expected = IO.read(markdown_name)
        expected.should be_kind_of(String)
        parser = Orgmode::Parser.new(IO.read(file), {:allow_include_files => false, :markup_file => custom_markup_file })
        actual = parser.to_markdown
        actual.should be_kind_of(String)
        actual.should == expected
      end
    end
  end

  describe "Export to HTML with incorrect custom markup test cases" do
    # The following tests export HTML to the default markup of org-ruby
    # since the YAML file only contains the incorrect keys
    data_directory = File.join(File.dirname(__FILE__), "html_with_custom_markup_examples")
    org_files = File.expand_path(File.join(data_directory, "*.org" ))
    files = Dir.glob(org_files)
    files.each do |file|
      basename = File.basename(file, ".org")
      default_html_name = File.join(data_directory, basename + "_default.html")
      default_html_name = File.expand_path(default_html_name)
      custom_markup_file = File.join(data_directory, "incorrect_markup_for_html.yml")
      custom_markup_file = File.expand_path(custom_markup_file)

      it "should convert #{basename}.org to HTML with the default markup" do
        expected = IO.read(default_html_name)
        expected.should be_kind_of(String)
        parser = Orgmode::Parser.new(IO.read(file), { :allow_include_files => true, :markup_file => custom_markup_file })
        actual = parser.to_html
        actual.should be_kind_of(String)
        actual.should == expected
      end
    end
  end

  describe "Export to HTML with missing custom markup file test cases" do
    # The following tests export HTML to the default markup of org-ruby
    # since the YAML file is missing.
    data_directory = File.join(File.dirname(__FILE__), "html_with_custom_markup_examples")
    org_files = File.expand_path(File.join(data_directory, "*.org" ))
    files = Dir.glob(org_files)
    files.each do |file|
      basename = File.basename(file, ".org")
      default_html_name = File.join(data_directory, basename + "_default.html")
      default_html_name = File.expand_path(default_html_name)
      custom_markup_file = File.join(data_directory, "this_file_does_not_exists.yml")
      custom_markup_file = File.expand_path(custom_markup_file)

      it "should convert #{basename}.org to HTML with the default markup" do
        expected = IO.read(default_html_name)
        expected.should be_kind_of(String)
        parser = Orgmode::Parser.new(IO.read(file), { :allow_include_files => true, :markup_file => custom_markup_file })
        actual = parser.to_html
        actual.should be_kind_of(String)
        actual.should == expected
      end
    end
  end

  describe "Export to HTML with custom markup test cases" do
    data_directory = File.join(File.dirname(__FILE__), "html_with_custom_markup_examples")
    org_files = File.expand_path(File.join(data_directory, "*.org" ))
    files = Dir.glob(org_files)
    files.each do |file|
      basename = File.basename(file, ".org")
      custom_html_name = File.join(data_directory, basename + ".html")
      custom_html_name = File.expand_path(custom_html_name)
      custom_markup_file = File.join(data_directory, "custom_markup_for_html.yml")
      custom_markup_file = File.expand_path(custom_markup_file)

      it "should convert #{basename}.org to HTML with custom markup" do
        expected = IO.read(custom_html_name)
        expected.should be_kind_of(String)
        parser = Orgmode::Parser.new(IO.read(file), { :allow_include_files => true, :markup_file => custom_markup_file })
        actual = parser.to_html
        actual.should be_kind_of(String)
        actual.should == expected
      end
    end
  end
end

