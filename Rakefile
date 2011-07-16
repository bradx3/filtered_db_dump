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

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "filtered_db_dump"
  gem.homepage = "http://github.com/bradx3/filtered_db_dump"
  gem.license = "MIT"
  gem.summary = %Q{Export trimmed mysql table dumps}
  gem.description = %Q{Easily set up mysql dumps that only dump data of interest. Useful for getting a development environment based on a production db}
  gem.email = "brad@lucky-dip.net"
  gem.authors = ["Brad Wilson"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

