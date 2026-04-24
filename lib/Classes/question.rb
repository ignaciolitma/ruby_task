require_relative 'conditions'

class Question
  attr_reader :id, :text, :condition

  def self.build(config)
    klass = case config['type']
            when 'text'     then TextQuestion
            when 'boolean'  then BooleanQuestion
            when 'radio'    then RadioQuestion
            when 'checkbox' then CheckboxQuestion
            when 'dropdown' then DropdownQuestion
            end
    klass.new(config)
  end

  def initialize(config)
    @id = config['id']
    @text = config['text']
    @condition = Conditions.build(config['condition'])
  end

  def visible?(responses)
    return true unless @condition
    @condition.met?(responses)
  end

  def print_visibility
    return "" unless @condition
    "\n   #{@condition.to_s}"
  end
end

require_relative 'boolean_question'
require_relative 'text_question'
require_relative 'radio_question'
require_relative 'checkbox_question'
require_relative 'dropdown_question'
require_relative 'options_question'

