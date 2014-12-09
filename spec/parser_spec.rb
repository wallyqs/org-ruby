require 'spec_helper'

describe Orgmode::Parser do
  it "should open ORG files" do
    parser = Orgmode::Parser.load(RememberFile)
  end

  it "should fail on non-existant files" do
    expect { parser = Orgmode::Parser.load("does-not-exist.org") }.to raise_error
  end

  it "should load all of the lines" do
    parser = Orgmode::Parser.load(RememberFile)
    expect(parser.lines.length).to eql(53)
  end

  it "should find all headlines" do
    parser = Orgmode::Parser.load(RememberFile)
    expect(parser.headlines.count).to eq(12)
  end

  it "can find a headline by index" do
    parser = Orgmode::Parser.load(RememberFile)
    line = parser.headlines[1].to_s
    expect(line).to eql("** YAML header in Webby\n")
  end

  it "should determine headline levels" do
    parser = Orgmode::Parser.load(RememberFile)
    expect(parser.headlines[0].level).to eql(1)
    expect(parser.headlines[1].level).to eql(2)
  end

  it "should include the property drawer items from a headline" do
    parser = Orgmode::Parser.load(FreeformExampleFile)
    expect(parser.headlines.first.property_drawer.count).to eq(2)
    expect(parser.headlines.first.property_drawer['DATE']).to eq('2009-11-26')
    expect(parser.headlines.first.property_drawer['SLUG']).to eq('future-ideas')
  end

  it "should put body lines in headlines" do
    parser = Orgmode::Parser.load(RememberFile)
    expect(parser.headlines[0].body_lines.count).to eq(1)
    expect(parser.headlines[1].body_lines.count).to eq(7)
  end

  it "should understand lines before the first headline" do
    parser = Orgmode::Parser.load(FreeformFile)
    expect(parser.header_lines.count).to eq(22)
  end

  it "should load in-buffer settings" do
    parser = Orgmode::Parser.load(FreeformFile)
    expect(parser.in_buffer_settings.count).to eq(12)
    expect(parser.in_buffer_settings["TITLE"]).to eql("Freeform")
    expect(parser.in_buffer_settings["EMAIL"]).to eql("bdewey@gmail.com")
    expect(parser.in_buffer_settings["LANGUAGE"]).to eql("en")
  end

  it "should understand OPTIONS" do
    parser = Orgmode::Parser.load(FreeformFile)
    expect(parser.options.count).to        eq(33)
    expect(parser.options["TeX"]).to       eql("t")
    expect(parser.options["todo"]).to      eql("t")
    expect(parser.options["\\n"]).to       eql("nil")
    expect(parser.options['H']).to         eq('3')
    expect(parser.options['num']).to       eq('t')
    expect(parser.options['toc']).to       eq('nil')
    expect(parser.options['\n']).to        eq('nil')
    expect(parser.options['@']).to         eq('t')
    expect(parser.options[':']).to         eq('t')
    expect(parser.options['|']).to         eq('t')
    expect(parser.options['^']).to         eq('t')
    expect(parser.options['-']).to         eq('t')
    expect(parser.options['f']).to         eq('t')
    expect(parser.options['*']).to         eq('t')
    expect(parser.options['<']).to         eq('t')
    expect(parser.options['TeX']).to       eq('t')
    expect(parser.options['LaTeX']).to     eq('nil')
    expect(parser.options['skip']).to      eq('nil')
    expect(parser.options['todo']).to      eq('t')
    expect(parser.options['pri']).to       eq('nil')
    expect(parser.options['tags']).to      eq('not-in-toc')
    expect(parser.options["'"]).to         eq('t')
    expect(parser.options['arch']).to      eq('headline')
    expect(parser.options['author']).to    eq('t')
    expect(parser.options['c']).to         eq('nil')
    expect(parser.options['creator']).to   eq('comment')
    expect(parser.options['d']).to         eq('(not LOGBOOK)')
    expect(parser.options['date']).to      eq('t')
    expect(parser.options['e']).to         eq('t')
    expect(parser.options['email']).to     eq('nil')
    expect(parser.options['inline']).to    eq('t')
    expect(parser.options['p']).to         eq('nil')
    expect(parser.options['stat']).to      eq('t')
    expect(parser.options['tasks']).to     eq('t')
    expect(parser.options['tex']).to       eq('t')
    expect(parser.options['timestamp']).to eq('t')

    expect(parser.export_todo?).to be true
    parser.options.delete("todo")
    expect(parser.export_todo?).to be false
  end

  it "should skip in-buffer settings inside EXAMPLE blocks" do
    parser = Orgmode::Parser.load(FreeformExampleFile)
    expect(parser.in_buffer_settings.count).to eq(0)
  end

  it "should return a textile string" do
    parser = Orgmode::Parser.load(FreeformFile)
    expect(parser.to_textile).to be_kind_of(String)
  end

  it "should understand export table option" do
    fname = File.join(File.dirname(__FILE__), %w[html_examples skip-table.org])
    data = IO.read(fname)
    p = Orgmode::Parser.new(data)
    expect(p.export_tables?).to be false
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
    expect(line.properties['block_name']).to eq('hello_world')
  end

  context "with a table that begins with a separator line" do
    let(:parser) { Orgmode::Parser.new(data) }
    let(:data) { Pathname.new(File.dirname(__FILE__)).join('data', 'tables.org').read }

    it "should parse without errors" do
      expect(parser.headlines.size).to eq(2)
    end
  end

  describe "Custom keyword parser" do
    fname = File.join(File.dirname(__FILE__), %w[html_examples custom-todo.org])
    p = Orgmode::Parser.load(fname)
    valid_keywords = %w[TODO INPROGRESS WAITING DONE CANCELED]
    invalid_keywords = %w[TODOX todo inprogress Waiting done cANCELED NEXT |]
    valid_keywords.each do |kw|
      it "should match custom keyword #{kw}" do
        expect(kw =~ p.custom_keyword_regexp).to be_truthy
      end
    end
    invalid_keywords.each do |kw|
      it "should not match custom keyword #{kw}" do
        expect((kw =~ p.custom_keyword_regexp)).to be_nil
      end
    end
    it "should not match blank as a custom keyword" do
      expect(("" =~ p.custom_keyword_regexp)).to be_nil
    end
  end

  describe "Custom include/exclude parser" do
    fname = File.join(File.dirname(__FILE__), %w[html_examples export-tags.org])
    p = Orgmode::Parser.load(fname)
    it "should load tags" do
      expect(p.export_exclude_tags.count).to eq(2)
      expect(p.export_select_tags.count).to eq(1)
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
        expect(expected).to be_kind_of(String)
        parser = Orgmode::Parser.new(IO.read(file))
        actual = parser.to_textile
        expect(actual).to be_kind_of(String)
        expect(actual).to eq(expected)
      end
    end
  end

  describe "Make it possible to disable rubypants pass" do
    it "should allow the raw dash" do
      org = "This is a dash -- that will remain as is."
      parser = Orgmode::Parser.new(org, { :skip_rubypants_pass => true })
      expected = "<p>#{org}</p>\n"
      expect(expected).to eq(parser.to_html)
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
        expect(expected).to be_kind_of(String)
        parser = Orgmode::Parser.new(IO.read(file), { :allow_include_files => true })
        actual = parser.to_html
        expect(actual).to be_kind_of(String)
        expect(actual).to eq(expected)
      end

      it "should render #{basename}.org to HTML using Tilt templates" do
        ENV['ORG_RUBY_ENABLE_INCLUDE_FILES'] = 'true'
        expected = IO.read(textile_name)
        template = Tilt.new(file).render
        expect(template).to eq(expected)
        ENV['ORG_RUBY_ENABLE_INCLUDE_FILES'] = ''
      end
    end

    it "should not render #+INCLUDE directive when explicitly indicated" do
      data_directory = File.join(File.dirname(__FILE__), "html_examples")
      expected = File.read(File.join(data_directory, "include-file-disabled.html"))
      org_file = File.join(data_directory, "include-file.org")
      parser = Orgmode::Parser.new(IO.read(org_file), :allow_include_files => false)
      actual = parser.to_html
      expect(actual).to eq(expected)
    end

    it "should render #+INCLUDE when ORG_RUBY_INCLUDE_ROOT is set" do
      data_directory = File.expand_path(File.join(File.dirname(__FILE__), "html_examples"))
      ENV['ORG_RUBY_INCLUDE_ROOT'] = data_directory
      expected = File.read(File.join(data_directory, "include-file.html"))
      org_file = File.join(data_directory, "include-file.org")
      parser = Orgmode::Parser.new(IO.read(org_file))
      actual = parser.to_html
      expect(actual).to eq(expected)
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
        expect(expected).to be_kind_of(String)
        parser = Orgmode::Parser.new(IO.read(file), {
                                       :allow_include_files   => true,
                                       :skip_syntax_highlight => true
                                     })
        actual = parser.to_html
        expect(actual).to be_kind_of(String)
        expect(actual).to eq(expected)
      end

      it "should render #{basename}.org to HTML using Tilt templates",
      :if => (defined? Coderay or defined? Pygments) do
        ENV['ORG_RUBY_ENABLE_INCLUDE_FILES'] = 'true'
        expected = IO.read(org_filename)
        template = Tilt.new(file).render
        expect(template).to eq(expected)
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
            expect(expected).to be_kind_of(String)
            parser = Orgmode::Parser.new(IO.read(file), :allow_include_files => true)
            actual = parser.to_html
            expect(actual).to be_kind_of(String)
            expect(actual).to eq(expected)
          end

          it "should render #{basename}.org to HTML using Tilt templates" do
            ENV['ORG_RUBY_ENABLE_INCLUDE_FILES'] = 'true'
            expected = IO.read(org_filename)
            template = Tilt.new(file).render
            expect(template).to eq(expected)
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
        expect(expected).to be_kind_of(String)
        parser = Orgmode::Parser.new(IO.read(file), :allow_include_files => false)
        actual = parser.to_markdown
        expect(actual).to be_kind_of(String)
        expect(actual).to eq(expected)
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
        expect(expected).to be_kind_of(String)
        parser = Orgmode::Parser.new(IO.read(file), { :allow_include_files => true, :markup_file => custom_markup_file })
        actual = parser.to_markdown
        expect(actual).to be_kind_of(String)
        expect(actual).to eq(expected)
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
        expect(expected).to be_kind_of(String)
        parser = Orgmode::Parser.new(IO.read(file), { :allow_include_files => true, :markup_file => custom_markup_file })
        actual = parser.to_markdown
        expect(actual).to be_kind_of(String)
        expect(actual).to eq(expected)
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
        expect(expected).to be_kind_of(String)
        parser = Orgmode::Parser.new(IO.read(file), {:allow_include_files => false, :markup_file => custom_markup_file })
        actual = parser.to_markdown
        expect(actual).to be_kind_of(String)
        expect(actual).to eq(expected)
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
        expect(expected).to be_kind_of(String)
        parser = Orgmode::Parser.new(IO.read(file), { :allow_include_files => true, :markup_file => custom_markup_file })
        actual = parser.to_html
        expect(actual).to be_kind_of(String)
        expect(actual).to eq(expected)
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
        expect(expected).to be_kind_of(String)
        parser = Orgmode::Parser.new(IO.read(file), { :allow_include_files => true, :markup_file => custom_markup_file })
        actual = parser.to_html
        expect(actual).to be_kind_of(String)
        expect(actual).to eq(expected)
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
        expect(expected).to be_kind_of(String)
        parser = Orgmode::Parser.new(IO.read(file), { :allow_include_files => true, :markup_file => custom_markup_file })
        actual = parser.to_html
        expect(actual).to be_kind_of(String)
        expect(actual).to eq(expected)
      end
    end
  end
end

