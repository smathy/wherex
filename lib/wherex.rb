require 'arel'
require 'active_record'
require 'active_support/core_ext'

require 'wherex/visitor'
require 'wherex/connection'
module Wherex
  ::Arel::Visitors::ToSql.send :include, Visitor
  ::Arel::Visitors::DepthFirst.send :include, Visitor
  ::ActiveRecord::Base.send :extend, ActiveRecord
end
