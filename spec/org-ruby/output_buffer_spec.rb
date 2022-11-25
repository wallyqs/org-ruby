require 'spec_helper'

require_relative '../../lib/org-ruby/output_buffer'
module Orgmode
  RSpec.describe OutputBuffer do
    let(:output) { 'Output' }
    let(:buffer) { Orgmode::OutputBuffer.new(output) }

    describe '.new' do
      it 'receives and has an output' do
        expect(buffer.output).to eq output
      end
    end

    describe 'get_next_headline_number' do
      let(:level) { 1 }
      context 'when @headline_number_stack is empty' do
        it 'returns 1' do
          headline_number = buffer.get_next_headline_number(level)
          expect(headline_number).to eq '1'
        end
      end

      context 'when @headline_number_stack has numbers' do
        let(:level) { 2 }
        before(:each) do
          buffer.headline_number_stack.push(4)
          buffer.headline_number_stack.push(2)
        end

        it 'returns 4.3' do
          headline_number = buffer.get_next_headline_number(level)
          expect(headline_number).to eq '4.3'
        end
      end
    end
  end
end
