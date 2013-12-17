module Wherex
  module Visitor

    def self.included base
      base.class_eval do
        alias_method_chain :visit_Arel_Nodes_Equality, :wherex
        alias_method_chain :visit_Arel_Nodes_NotEqual, :wherex
      end
    end

    def visit_Arel_Nodes_Equality_with_wherex o, a = nil
      right = o.right
      if right.present? and right.is_a? Regexp
        ::ActiveRecord::Base.connection.regexp visit(o.left), visit(right)
      else
        visit_Arel_Nodes_Equality_without_wherex o, a
      end
    end

    def visit_Arel_Nodes_NotEqual_with_wherex o, a = nil
      right = o.right
      if right.present? and right.is_a? Regexp
        ::ActiveRecord::Base.connection.regexp_not visit(o.left), visit(right)
      else
        visit_Arel_Nodes_NotEqual_without_wherex o, a
      end
    end

    def visit_Regexp(o, a = nil)
      ::ActiveRecord::Base.connection.regexp_quote(o.source)
    end

  end
end

