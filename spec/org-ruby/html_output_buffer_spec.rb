require 'spec_helper'
require_relative '../../lib/org-ruby/html_output_buffer'

module Orgmode
  RSpec.describe HtmlOutputBuffer do
    let(:output) { "Buffer" }
    let(:buffer) { Orgmode::HtmlOutputBuffer.new(output) }

    describe '.new' do
      it 'has an output buffer' do
        expect(buffer).not_to be_nil
        expect(buffer.output).to eq output
      end

      it 'has HTML buffer_tag' do
        expect(buffer.buffer_tag).to eq 'HTML'
      end

      context 'when call with options' do
        let(:options) { { option: 'value'} }
        let(:buffer) { Orgmode::HtmlOutputBuffer.new(output, options)}
        it 'has options' do
          expect(buffer.options).to eq options
        end
      end
    end

    describe '#push_mode' do
      context 'when mode is a HtmlBlockTag' do
        let(:mode) { :paragraph }
        let(:indent) { :some_value }
        let(:properties) { Hash.new }

        it 'push HtmlBlock to the output buffer' do
          buffer.push_mode(mode, indent, properties)
          expect(buffer.output).to eq 'Buffer<p>'
        end

        context 'when mode is example' do
          let(:mode) { :example }
          it 'sets class attributes to example' do
            buffer.push_mode(mode, indent)
            expect(buffer.output).to eq 'Buffer<pre class="example">'
          end
        end

        context 'when mode is inline_example' do
          let(:mode) { :inline_example }
          it 'sets class attributes to example' do
            buffer.push_mode(mode, indent)
            expect(buffer.output).to eq 'Buffer<pre class="example">'
          end
        end

        context 'when mode is center' do
          let(:mode) { :center }
          it 'sets style attribute to text-align: center' do
            buffer.push_mode(mode, indent)
            expect(buffer.output).to eq 'Buffer<div style="text-align: center">'
          end
        end

        context 'when mode is src' do
          let(:mode) { :src }

          context 'when Buffer options include skip_syntax_highlight = true' do
            let(:buffer) { Orgmode::HtmlOutputBuffer.new(output, { skip_syntax_highlight: true })}
            before(:each) do
              allow(buffer).to receive(:block_lang).and_return('')
            end

            it 'sets class attributes' do
              buffer.push_mode(mode, indent)
              expect(buffer.output).to eq 'Buffer<pre class="src">'
            end

            context 'when Buffer block_lang is not empty' do
              let(:block_lang) { 'elisp' }

              before(:each) do
                allow(buffer).to receive(:block_lang).and_return(block_lang)
              end

              it 'set lang attribute' do
                buffer.push_mode(mode, indent, properties)
                expect(buffer.output).to eq 'Buffer<pre class="src" lang="elisp">'
              end
            end
          end
        end

        context 'when called for second time' do
          before(:each) do
            buffer.push_mode(mode, indent)
          end

          it 'does not add paragprah' do
            mode = :src
            buffer.push_mode(mode, 'indent')
            expect(buffer.output).not_to match(/\Z\n/)
          end
        end
      end
    end
  end
end
