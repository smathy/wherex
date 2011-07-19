module Wherex
  module ActiveRecord
    def self.extended base
      base.class_eval do
        class << self
          alias_method_chain :establish_connection, :wherex
        end
      end
    end

    def establish_connection_with_wherex spec = nil
      establish_connection_without_wherex spec

      require 'wherex/adapters'
      ::ActiveRecord::ConnectionAdapters::AbstractAdapter.send :include, AbstractAdapter

      adapter = ::ActiveRecord::Base.connection.class
      my_adapter_name = adapter.to_s.demodulize

      begin
        my_adapter = "Wherex::#{my_adapter_name}".constantize
        adapter.send :include, my_adapter
      rescue NameError => e
      end

      if ::ActiveRecord::Base.connection.raw_connection.respond_to? :create_function
        ::ActiveRecord::Base.connection.raw_connection.create_function( "regexp", 2 ) do |context, pattern, string|
          if string.present?
            context.result = 1 if string.match pattern
          end
        end
      end
    end
  end
end
