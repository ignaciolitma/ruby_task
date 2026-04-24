module Conditions
  def self.build(config)
    return nil unless config
    case config['type']
    when 'value' then Value.new(config['question_id'], config['value'], config['label'])
    when 'and'   then And.new(config['conditions'].map { |c| build(c) })
    when 'or'    then Or.new(config['conditions'].map { |c| build(c) })
    when 'not'   then Not.new(build(config['condition']))
    end
  end

  class Value < Struct.new(:question_id, :value, :label)
    def met?(responses)
      responses[question_id] == value
    end

    def to_s(prefix = "Visible")
      "<#{prefix}> #{label}: #{value.inspect}"
    end
  end

  class And < Struct.new(:conditions)
    def met?(responses)
      conditions.all? { |c| c.met?(responses) }
    end

    def to_s
      conditions.map { |c| c.to_s("AND Visible") }.join("\n   ")
    end
  end

  class Or < Struct.new(:conditions)
    def met?(responses)
      conditions.any? { |c| c.met?(responses) }
    end

    def to_s
      conditions.map { |c| c.to_s("OR Visible") }.join("\n   ")
    end
  end

  class Not < Struct.new(:condition)
    def met?(responses)
      !condition.met?(responses)
    end

    def to_s
      condition.to_s("NOT Visible")
    end
  end
end
