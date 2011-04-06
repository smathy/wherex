$:.push File.expand_path("../lib", __FILE__)
require "wherex/version"

Gem::Specification.new do |s|
  s.name        = "wherex"
  s.version     = Wherex::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jason King"]
  s.email       = ["jk@handle.it"]
  s.homepage    = ""
  s.summary     = %q{Adds regexp to Arel finders}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "wherex"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
