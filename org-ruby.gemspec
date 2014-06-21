# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "org-ruby/version"

Gem::Specification.new do |s|
  s.name = "org-ruby"
  s.version = OrgRuby::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors           = ["Brian Dewey", "Waldemar Quevedo"]
  s.date              = Time.now.strftime("%Y-%m-%d")
  s.description       = "An Org mode parser written in Ruby."
  s.email             = "waldemar.quevedo@gmail.com"
  s.executables       = ["org-ruby"]
  s.extra_rdoc_files  = ["History.org", "README.org", "bin/org-ruby"]
  s.files             = ["History.org", "README.org", "bin/org-ruby", "lib/org-ruby.rb", "lib/org-ruby/headline.rb", "lib/org-ruby/html_output_buffer.rb", "lib/org-ruby/html_symbol_replace.rb", "lib/org-ruby/line.rb", "lib/org-ruby/output_buffer.rb", "lib/org-ruby/parser.rb", "lib/org-ruby/regexp_helper.rb", "lib/org-ruby/markdown_output_buffer.rb", "lib/org-ruby/textile_output_buffer.rb", "lib/org-ruby/textile_symbol_replace.rb", "lib/org-ruby/tilt.rb", "lib/org-ruby/version.rb"]
  s.homepage          = "https://github.com/wallyqs/org-ruby"
  s.require_paths     = ["lib"]
  s.rubyforge_project = "org-ruby"
  s.rubygems_version  = "1.8.10"
  s.summary           = "This gem contains Ruby routines for parsing org-mode files."
  s.license           = "MIT"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rubypants>, ["~> 0.2"])
    else
      s.add_dependency(%q<rubypants>, ["~> 0.2"])
    end
  else
    s.add_dependency(%q<rubypants>, ["~> 0.2"])
  end
end
