# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "filtered_db_dump/version"

Gem::Specification.new do |s|
  s.name        = "filtered_db_dump"
  s.version     = FilteredDbDump::VERSION
  s.authors     = ["Brad Wilson"]
  s.email       = ["brad@lucky-dip.net"]
  s.homepage = "http://github.com/bradx3/filtered_db_dump"
  s.summary     = %Q{Export trimmed mysql table dumps}
  s.description = %Q{Easily set up mysql dumps that only dump data of interest. Useful for getting a development environment based on a production db}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
