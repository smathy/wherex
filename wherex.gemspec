$:.push File.expand_path("../lib", __FILE__)
require "wherex/version"

Gem::Specification.new do |s|
  s.name        = "wherex"
  s.version     = Wherex::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jason King"]
  s.email       = ["jk@handle.it"]
  s.homepage    = "http://github.com/smathy/wherex"
  s.license     = "MIT"
  s.summary     = %q{Regexp for ActiveRecord finders}
  s.description = %q{This gem allows you to pass a Regexp as the value for any finder in ActiveRecord - Rails3 only}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = s.files.grep /^test/
  s.require_paths = ["lib"]

  s.add_dependency 'activerecord', '>= 3.1'

  case ENV["DB"]
  when "postgres", "postgresql", "pg"
    s.add_development_dependency 'pg'
  when "mysql", "mysql2"
    s.add_development_dependency 'mysql2'
  else
    s.add_development_dependency 'sqlite3', ">= 1.3.7"
  end

  s.add_development_dependency 'rake', '>= 1.0'

end
