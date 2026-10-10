desc "Benchmark parsing and exporting (ruby util/bench.rb [multiplier] [lib])"
task :bench, [:multiplier, :lib] do |t, args|
  ruby File.join(__dir__, "..", "util", "bench.rb"), *[args[:multiplier], args[:lib]].compact
end
