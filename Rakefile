require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
  spec.rspec_opts = ["--format", "documentation", "--colour"]
end

Dir['tasks/*'].each {|task| import task }

task :test do
  runs = {
    "without CodeRay nor Pygments" => "pygments:coderay",
    "with CodeRay"                 => "pygments",
    "with Pygments"                => "coderay",
  }

  results = runs.map do |desc, without|
    puts "Testing #{desc} for code syntax highlight"
    system({ "BUNDLE_WITHOUT" => without }, "bundle exec rake spec")
  end

  exit results.all?
end

task :default => 'test'
