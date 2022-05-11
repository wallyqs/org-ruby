require 'spec_helper'

describe Orgmode::HtmlOutputBuffer do
  it 'generates html headings ids' do
    lines = "* Hello\n** World"
    parser_options = {:generate_heading_id => true}
    expected_output = "<h1 id=\"hello\">Hello</h1>\n<h2 id=\"hello--world\">World</h2>"
    actual_output = Orgmode::Parser.new(lines, parser_options).to_html.strip
    expect(actual_output).to eql(expected_output)
  end
end
