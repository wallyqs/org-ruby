require 'spec_helper'

describe Orgmode::OutputBuffer do

  it "computes outline level numbering" do
    output_buffer = Orgmode::OutputBuffer.new ""
    expect(output_buffer.get_next_headline_number(1)).to eql("1")
    expect(output_buffer.get_next_headline_number(1)).to eql("2")
    expect(output_buffer.get_next_headline_number(1)).to eql("3")
    expect(output_buffer.get_next_headline_number(1)).to eql("4")
    expect(output_buffer.get_next_headline_number(2)).to eql("4.1")
    expect(output_buffer.get_next_headline_number(2)).to eql("4.2")
    expect(output_buffer.get_next_headline_number(1)).to eql("5")
    expect(output_buffer.get_next_headline_number(2)).to eql("5.1")
    expect(output_buffer.get_next_headline_number(2)).to eql("5.2")
    expect(output_buffer.get_next_headline_number(4)).to eql("5.2.0.1")
  end

  describe Orgmode::HtmlOutputBuffer do
    it 'generates html ids' do
      lines = '* Hello world!'
      parser_options = { export_heading_id: true }
      expected_output = '<h1><span id="hello-world"></span>Hello world!</h1>'
      actual_output = Orgmode::Parser.new(lines, parser_options).to_html.strip
      expect(actual_output).to eql(expected_output)
    end
  end
end
