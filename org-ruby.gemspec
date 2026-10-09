# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "org-ruby/version"

Gem::Specification.new do |s|
  s.name = "org-ruby"
  s.version = OrgRuby::VERSION

  s.authors           = ["Brian Dewey", "Waldemar Quevedo"]
  s.description       = "An Org mode parser written in Ruby."
  s.email             = "waldemar.quevedo@gmail.com"
  s.executables       = ["org-ruby"]
  s.extra_rdoc_files  = ["History.org", "README.org", "bin/org-ruby"]
  s.files             = ["History.org", "README.org", "bin/org-ruby"] + Dir["lib/**/*.rb"]
  s.homepage          = "https://github.com/wallyqs/org-ruby"
  s.require_paths     = ["lib"]
  s.summary           = "This gem contains Ruby routines for parsing org-mode files."
  s.license           = "MIT"
  s.metadata          = { "source_code_uri" => "https://github.com/wallyqs/org-ruby" }

  s.required_ruby_version = ">= 3.1"

  s.add_dependency "rubypants", "~> 0.7"
  # logger is no longer a default gem as of Ruby 4.0
  s.add_dependency "logger", ">= 1.5"
end
