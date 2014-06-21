require 'org-ruby'

namespace :testcase do
  @data_directory = File.join(File.dirname(__FILE__), "../spec/html_examples")
  
  desc "List all of the current HTML test cases"
  task :list do
    org_files = File.expand_path(File.join(@data_directory, "*.org" ))
    files = Dir.glob(org_files)
    files.each do |file|
      puts File.basename(file, ".org")
    end
  end

  desc "Accept the current org-ruby output for the test case as correct"
  task :accept, :case do |t, args|
    basename = args[:case]
    raise "Must supply a test case name. Example: rake testcase:accept[casename]" unless basename
    fname = File.expand_path(File.join(@data_directory, "#{basename}.org"))
    oname = File.expand_path(File.join(@data_directory, "#{basename}.html"))
    data = IO.read(fname)
    puts "=== #{fname} is:          ===>>>\n\n"
    puts data
    puts "\n\n=== ACCEPTING OUTPUT: ===>>>\n\n"
    p = Orgmode::Parser.new(data)
    puts p.to_html
    File.open(oname, "w") do |s|
      s.write(p.to_html)
    end
  end

  desc "Look at the current org-ruby output for a test case"
  task :inspect, :case do |t, args|
    basename = args[:case]
    raise "Must supply a test case name. Example: rake testcase:accept[casename]" unless basename
    fname = File.expand_path(File.join(@data_directory, "#{basename}.org"))
    data = IO.read(fname)
    puts "=== #{fname} is:          ===>>>\n\n"
    puts data
    puts "\n\n=== #{fname} converts to: ===>>>\n\n"
    p = Orgmode::Parser.new(data)
    puts p.to_html
  end

  # Special namespace to test syntax highlighting with different technologies
  namespace :highlight do
    @code_syntax_examples_directory = File.join(File.dirname(__FILE__), "../spec/html_code_syntax_highlight_examples")

    desc "List all of the current HTML test cases"
    task :list do
      org_files = File.expand_path(File.join(@code_syntax_examples_directory, "*.org" ))
      files = Dir.glob(org_files)
      files.each do |file|
        puts File.basename(file, ".org")
      end
    end

    desc "Special tests cases for code syntax highlight support"
    task :accept, :case do |t, args|
      basename = args[:case]
      raise "Must supply a test case name. Example: rake testcase:accept[casename]" unless basename

      fname = File.expand_path(File.join(@code_syntax_examples_directory, "#{basename}.org"))
      oname = File.expand_path(File.join(@code_syntax_examples_directory, "#{basename}.html"))

      data = IO.read(fname)
      puts "=== #{fname} is:          ===>>>\n\n"
      puts data
      puts "\n\n=== ACCEPTING OUTPUT: ===>>>\n\n"
      p = Orgmode::Parser.new(data)
      puts p.to_html
      File.open(oname, "w") do |s|
        s.write(p.to_html)
      end
    end

    desc "Inspect code syntax highlight support"
    task :inspect, :case do |t, args|
      basename = args[:case]
      raise "Must supply a test case name. Example: rake testcase:inspecthighlight[casename]" unless basename

      fname = File.expand_path(File.join(@code_syntax_examples_directory, "#{basename}.org"))

      data = IO.read(fname)
      puts "=== #{fname} is:          ===>>>\n\n"
      puts data
      puts "\n\n=== #{fname} converts to: ===>>>\n\n"
      p = Orgmode::Parser.new(data)
      puts p.to_html
    end
  end

end

desc "Alias for testcase:list"
task :testcase => ["testcase:list"]
