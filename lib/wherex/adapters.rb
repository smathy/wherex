module Wherex
  module AbstractAdapter

    def regexp_operator
      "REGEXP"
    end

    def regexp_not_operator
      "NOT #{regexp_operator}"
    end

    def regexp left, right
      "#{left} #{regexp_operator} #{right}"
    end

    def regexp_not left, right
      "#{left} #{regexp_not_operator} #{right}"
    end

    def regexp_quote str
      quote str
    end
  end

  module PostgreSQLAdapter

    def regexp_operator
      "~"
    end

    def regexp_not_operator
      "!~"
    end
  end
end
