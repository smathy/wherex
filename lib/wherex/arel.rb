module Wherex
  module Arel

    def visit_Arel_Nodes_Equality_with_wherex o
      right = o.right
      if right.present? and right.is_a? Regexp
        "#{visit o.left} #{@connection.regexp_operator} #{visit right}"
      else
        visit_Arel_Nodes_Equality_without_wherex o
      end
    end

    alias_method_chain :visit_Arel_Nodes_Equality, :wherex
  end
end

