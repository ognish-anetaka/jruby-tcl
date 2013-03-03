# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

task :libjar do
  unless File.exist?("./lib/jacl.jar") or
        File.exist?("./lib/tcljava.jar") 
    ruby 'ext/download.rb'
  end
end
[:test,:build,:gemspec,:install].each do |t|
  task t => [:libjar]
end

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.platform = "java"
  gem.name = "jruby-tcl"
  gem.homepage = "http://github.com/ognish-anetaka/jruby-tcl"
  gem.summary = %Q{ruby-tcl version of JRuby}
  gem.description = %Q{#{gem.summary}, See RAEDME for more details.}
  gem.email = "ognish.anetaka@gmail.com"
  gem.authors = ["ognish.anetaka"]
  # dependencies defined in Gemfile
  gem.files = Dir["lib/**/*.rb", "lib/**/*.jar"]
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

#require 'rcov/rcovtask'
#Rcov::RcovTask.new do |test|
#  test.libs << 'test'
#  test.pattern = 'test/**/*_test.rb'
#  test.verbose = true
#  test.rcov_opts << '--exclude "gems/*"'
#end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "jruby-tcl #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
