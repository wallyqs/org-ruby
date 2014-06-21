require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
  spec.rspec_opts = ["--format", "documentation", "--colour"]
end

Dir['tasks/*'].each {|task| import task }

task :test do
  exit_status = nil

  puts "Testing without CodeRay nor Pygments for code syntax highlight"
  system('bundle --without pygments:coderay > /dev/null 2>&1')
  exit_status = system('bundle exec rake spec')

  puts "Testing with CodeRay for code syntax highlight"
  system('bundle --without pygments > /dev/null 2>&1')
  exit_status = system('bundle exec rake spec')

  puts "Testing with Pygments for code syntax highlight"
  system('bundle --without coderay > /dev/null 2>&1')
  exit_status = system('bundle exec rake spec')

  exit exit_status
end

task :default => 'test'
