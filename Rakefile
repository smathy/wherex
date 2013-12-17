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

spec = Gem::Specification.load( File.join( File.dirname(__FILE__), 'wherex.gemspec' ) )

$:.push File.expand_path("../lib", __FILE__)
require "wherex/version"

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'simplecov'
task :test_coverage do
   ENV['COVERAGE'] = 'true'
   Rake::Task["test"].execute
end

if ENV["COVERAGE"]
  SimpleCov.start do
    add_filter '/lib/'
    add_filter '/test/'
  end
end

task :default => :test
