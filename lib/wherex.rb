require 'wherex/visitor'
require 'wherex/connection'
module Wherex
  ::Arel::Visitors::ToSql.send :include, Visitor
  ::ActiveRecord::Base.send :extend, ActiveRecord
end
