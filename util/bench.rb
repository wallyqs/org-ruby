#!/usr/bin/env ruby
# Benchmarks parsing and exporting a synthetic corpus built from the
# spec examples. Usage:
#
#   ruby util/bench.rb [multiplier] [path/to/lib]
#
# The multiplier repeats the corpus (default 8, about 21k lines). Pass a
# second argument to benchmark another checkout of the library, e.g. a
# git worktree of main, for an A/B comparison.
require 'benchmark'

multiplier = (ARGV[0] || 8).to_i
lib = File.expand_path(ARGV[1] || File.join(__dir__, '..', 'lib'))
$:.unshift lib
require 'org-ruby'

examples = File.join(__dir__, '..', 'spec', 'html_examples', '*.org')
# Drop in-buffer settings that would apply to the whole concatenated
# corpus (export tag selection in particular hides nearly everything).
corpus = Dir[examples].sort.reject { |f| f =~ /include-file/ }.map do |f|
  File.read(f, encoding: 'UTF-8').gsub(/^#\+(EXPORT_SELECT_TAGS|EXPORT_EXCLUDE_TAGS|OPTIONS|TITLE|SEQ_TODO|TYP_TODO|TODO|INCLUDE):.*\n/i, "")
end.join("\n\n")
text = ([corpus] * multiplier).join("\n\n")

best = Hash.new(Float::INFINITY)
5.times do
  parser = nil
  best[:parse]    = [best[:parse],    Benchmark.realtime { parser = Orgmode::Parser.new(text, skip_syntax_highlight: true) }].min
  best[:html]     = [best[:html],     Benchmark.realtime { parser.to_html }].min
  best[:markdown] = [best[:markdown], Benchmark.realtime { parser.to_markdown }].min
  best[:textile]  = [best[:textile],  Benchmark.realtime { parser.to_textile }].min
end

puts "org-ruby #{OrgRuby::VERSION} (#{lib}), #{RUBY_DESCRIPTION}"
puts "corpus: #{text.lines.size} lines, #{text.bytesize} bytes, best of 5 runs"
best.each { |phase, secs| printf "  %-9s %.3fs\n", phase, secs }
puts "html output: #{Orgmode::Parser.new(text, skip_syntax_highlight: true).to_html.bytesize} bytes" 
