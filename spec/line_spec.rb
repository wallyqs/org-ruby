require 'spec_helper'

describe Orgmode::Line do

  it "should tell comments" do
    comments = ["# hello", " # hello" ]
    comments.each do |c|
      line = Orgmode::Line.new c
      expect(line.comment?).to be_truthy
    end

    not_comments = ["", "\n", "hello\n", "  foo ### bar\n"]
    not_comments.each do |c|
      line = Orgmode::Line.new c
      expect(line.comment?).to be_falsy
    end
  end

  it "should tell blank lines" do
    blank = ["", " ", "\t", "\n", "  \t\t\n\n"]
    blank.each do |b|
      line = Orgmode::Line.new b
      expect(line.blank?).to be_truthy
    end
  end

  [": inline", " : inline", "\t\t:\tinline"].each do |inline_example|
    it "should recognize this inline example: #{inline_example}" do
      expect(Orgmode::Line.new(inline_example).inline_example?).to be_truthy
    end
  end

  list_formats = ["- ",
                  "+ ",
                  "  - ",
                  "  + ",
                  " 1. ",
                  " 2) "]
  list_formats.each do |list|
    it "should recognize this list format: '#{list}'" do
      line = Orgmode::Line.new list
      expect(line.plain_list?).to be_truthy
    end
  end

  ["-foo", "+foo", "1.foo", "2.foo"].each do |invalid_list|
    it "should not recognize this invalid list: '#{invalid_list}'" do
      line = Orgmode::Line.new invalid_list
      expect(line.plain_list?).to be_falsy
    end
  end

  it "should recognize horizontal rules" do
    expect(Orgmode::Line.new("-----").horizontal_rule?).to be_truthy
    expect(Orgmode::Line.new("----------").horizontal_rule?).to be_truthy
    expect(Orgmode::Line.new("   \t ----- \t\t\t").horizontal_rule?).to be_truthy
    expect(Orgmode::Line.new("----").horizontal_rule?).to be_falsy
  end

  it "should recognize table rows" do
   expect(Orgmode::Line.new("| One   | Two   | Three |").table_row?).to be_truthy
   expect(Orgmode::Line.new("  |-------+-------+-------|\n").table_separator?).to be_truthy
   expect(Orgmode::Line.new("| Four  | Five  | Six   |").table_row?).to be_truthy
   expect(Orgmode::Line.new("| Seven | Eight | Nine  |").table_row?).to be_truthy
  end

  it "should recognize indentation" do
    expect(Orgmode::Line.new("").indent).to eql(0)
    expect(Orgmode::Line.new(" a").indent).to eql(1)
    expect(Orgmode::Line.new("   ").indent).to eql(0)
    expect(Orgmode::Line.new("   \n").indent).to eql(0)
    expect(Orgmode::Line.new("   a").indent).to eql(3)
  end

  it "should return paragraph type" do
    expect(Orgmode::Line.new("").paragraph_type).to eql(:blank)
    expect(Orgmode::Line.new("1. foo").paragraph_type).to eql(:list_item)
    expect(Orgmode::Line.new("- [ ] checkbox").paragraph_type).to eql(:list_item)
    expect(Orgmode::Line.new("hello!").paragraph_type).to eql(:paragraph)
  end

  it "should recognize BEGIN and END comments" do
    begin_examples = {
      "#+BEGIN_SRC emacs-lisp -n -r\n" => "SRC",
      "#+BEGIN_EXAMPLE" => "EXAMPLE",
      "\t#+BEGIN_QUOTE  " => "QUOTE"
    }

    end_examples = {
      "#+END_SRC" => "SRC",
      "#+END_EXAMPLE" => "EXAMPLE",
      "\t#+END_QUOTE  " => "QUOTE"
    }

    begin_examples.each_key do |str|
      line = Orgmode::Line.new str
      expect(line.begin_block?).to be_truthy
      expect(line.block_type).to eql(begin_examples[str])
    end

    end_examples.each_key do |str|
      line = Orgmode::Line.new str
      expect(line.end_block?).to be_truthy
      expect(line.block_type).to eql(end_examples[str])
    end
  end

  context "when a block has header arguments" do
    cases = {
      "#+begin_src :hello world" => {
        ':hello' => 'world'
      },
      "#+begin_src ruby -n -r -l \"asdf\" asdf asdf :asdf asdf" => {
        ':asdf' => 'asdf'
      },
      "#+begin_src ruby :results \"he:llo\" :results :hello :tangle somewhere.rb :exports code :shebang #!/bin/bash" => {
        ':results' => '"he:llo"', ':tangle' => 'somewhere.rb', ':exports' => 'code', ':shebang' => '#!/bin/bash'
      },
      "#+begin_src clojure :results :hello :tangle somewhere.rb :exports code" => {
        ':tangle' => 'somewhere.rb', ':exports' => 'code'
      },
      "#+begin_src js :results output :hello :tangle somewhere.rb :exports code" => {
        ':results' => 'output', ':tangle' => 'somewhere.rb', ':exports' => 'code'
      }
    }

    cases.each_pair do |example, expected|
      it "should recognize #{example}" do 
        line = Orgmode::Line.new example
        expect(line.block_header_arguments).to eq(expected)
      end
    end
  end

  context "when initializing" do
    cases = {
      "# this looks like a comment" => :comment,
      "  1. This looks like an ordered list" => :ordered_list,
      "       - this looks like an # unordered list" => :unordered_list,
      " | one | two | table! |  \n" => :table_row,
      "\n" => :blank,
      " |-----+-----+--------|  \n" => :table_separator
    }

    cases.each_pair do |example, expected|
      it "should accept '#{example}' with assigned type #{expected}" do 
        line = Orgmode::Line.new(example, nil, expected)
        expect(line.assigned_paragraph_type).to eq(expected)
      end
    end
  end

  it "should parse in-buffer settings" do
    cases = {
      "#+ARCHIVE: %s_done" => { :key => "ARCHIVE", :value => "%s_done" },
      "#+CATEGORY: foo" => { :key => "CATEGORY", :value => "foo"},
      "#+BEGIN_EXAMPLE:" => { :key => "BEGIN_EXAMPLE", :value => "" },
      "#+A:" => { :key => "A", :value => "" } # Boundary: Smallest keyword is one letter
    }
    cases.each_pair do |key, value|
      l = Orgmode::Line.new key
      expect(l.in_buffer_setting?).to be_truthy
      called = nil
      l.in_buffer_setting? do |k, v|
        expect(k).to eql(value[:key])
        expect(v).to eql(value[:value])
        called = true
      end
      expect(called).to be true
    end
  end

  it "should reject ill-formed settings" do
    cases = [
             "##+ARCHIVE: blah",
             "#CATEGORY: foo",
             "",
             "\n",
             "   #+BEGIN_EXAMPLE:\n"
            ]

    cases.each do |c|
      l = Orgmode::Line.new c
      expect(l.in_buffer_setting?).to be_nil
    end
  end

  context "at the start of a results block" do
    cases = [
             "#+RESULTS: hello-world",
             "#+RESULTS: ",
             "#+RESULTS:",
             "#+results: HELLO-WORLD",
             "#+results: ",
             "#+results:"
            ]
    cases.each do |c|
      it "should recognize #{c}" do 
        l = Orgmode::Line.new(c).start_of_results_code_block?
        expect(l).to be_truthy
      end
    end
  end

  it "should recognize an included file" do
    expect(Orgmode::Line.new("#+INCLUDE: \"~/somefile.org\"").include_file?).to be_truthy
  end

  it "should recognize an included file with specific lines" do
    expect(Orgmode::Line.new("#+INCLUDE: \"~/somefile.org\" :lines \"4-18\"").include_file?).to be_truthy
  end

  it "should recognize an included code file" do
    expect(Orgmode::Line.new("#+INCLUDE: \"~/somefile.org\" src ruby").include_file?).to be_truthy
  end
end
