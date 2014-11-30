ENV['DB'] = ( ENV['DB'] || 'sqlite' ).downcase

require 'minitest/autorun'
require 'minitap'

if defined? Minitap
  Minitest.reporter = Minitap::TapY
else
  MiniTest::Unit.runner = MiniTest::TapY.new
end

require 'wherex'
require 'active_record/fixtures'

ROOT_PATH = File.expand_path( File.join( File.dirname(__FILE__) ))

config = YAML::load(ERB.new(IO.read(File.join( ROOT_PATH, 'config', 'database.yml'))).result)['test'][ENV['DB']]

ActiveRecord::Base.establish_connection config

dep = defined?(ActiveSupport::Dependencies) ? ActiveSupport::Dependencies : ::Dependencies
dep.autoload_paths.unshift File.join( ROOT_PATH, 'app/models' )

FIXTURES_PATH = File.join(File.dirname(__FILE__), 'fixtures')
dep.autoload_paths.unshift FIXTURES_PATH

ActiveRecord::Migration.verbose = false
load File.join(FIXTURES_PATH, 'schema.rb')

FIXTURE_CLASS = 
begin
  ActiveRecord::FixtureSet
rescue NameError
  begin
    ActiveRecord::Fixtures
  rescue NameError
    Fixtures
  end
end

FIXTURE_CLASS.create_fixtures(FIXTURES_PATH, ActiveRecord::Base.connection.tables)

TEST_CLASS = defined?(Minitest::Test) ? Minitest::Test : MiniTest::Unit::TestCase

class TEST_CLASS
  def method_missing method, *args
    candidate = method.to_s.classify
    begin
      candidate.constantize.find( FIXTURE_CLASS.identify args[0] )
    rescue NameError
      raise NameError.new "undefined local variable or method `#{method}`"
    end
  end
end
