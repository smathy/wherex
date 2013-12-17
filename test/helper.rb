ENV['RAILS_DB'] = ( ENV['RAILS_DB'] || 'sqlite' ).downcase

require 'rubygems'
require 'bundler'
Bundler.setup
require 'test/unit'
begin; require 'redgreen'; rescue LoadError; end
begin; require 'turn'; rescue LoadError; end

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'wherex'
require 'active_record/fixtures'

ROOT_PATH = File.expand_path( File.join( File.dirname(__FILE__) ))
FIXTURES_PATH = File.join(File.dirname(__FILE__), 'fixtures')

config = YAML::load(ERB.new(IO.read(File.join( ROOT_PATH, 'config', 'database.yml'))).result)['test'][ENV['RAILS_DB']]

ActiveRecord::Base.establish_connection config

dep = defined?(ActiveSupport::Dependencies) ? ActiveSupport::Dependencies : ::Dependencies
dep.autoload_paths.unshift File.join( ROOT_PATH, 'app/models' )

dep.autoload_paths.unshift FIXTURES_PATH

ActiveRecord::Migration.verbose = false
load File.join(FIXTURES_PATH, 'schema.rb')

ActiveRecord::FixtureSet.create_fixtures(FIXTURES_PATH, ActiveRecord::Base.connection.tables)

class Test::Unit::TestCase
  def method_missing method, *args
    candidate = method.to_s.classify
    begin
      candidate.constantize.find( ActiveRecord::FixtureSet.identify args[0] )
    rescue NameError
      raise NameError.new "undefined local variable or method `#{method}`"
    end
  end
end
