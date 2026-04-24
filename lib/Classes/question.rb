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

class OptionsQuestion < Question
  def initialize(config)
    super
    @options = build_options(config)
  end

  def build_options(config)
    opts = config['options'] || []
    case config['preset']
    when 'genders' then opts = [{ 'label' => 'Male', 'value' => 'male' }, { 'label' => 'Female', 'value' => 'female' }, { 'label' => 'X', 'value' => 'x' }]
    when 'states'  then opts = [{ 'label' => 'California', 'value' => 'ca' }, { 'label' => 'Florida', 'value' => 'fl' }, { 'label' => 'New York', 'value' => 'ny' }, { 'label' => 'Texas', 'value' => 'tx' }, { 'label' => 'Washington', 'value' => 'wa' }]
    when 'countries' then opts = [{ 'label' => 'Canada', 'value' => 'ca' }, { 'label' => 'Mexico', 'value' => 'mx' }]
    end
    opts
  end
end

class RadioQuestion < OptionsQuestion
  def render(response, index)
    out = "#{index}. #{@text} (radio question)#{print_visibility}"
    @options.each do |opt|
      mark = response == opt['value'] ? 'x' : ' '
      out += "\n  - (#{mark}) #{opt['label']} (value: '#{opt['value']}')"
    end
    out
  end
end

class CheckboxQuestion < OptionsQuestion
  def render(response, index)
    responses = response || []
    out = "#{index}. #{@text} (checkbox question)#{print_visibility}"
    @options.each do |opt|
      mark = responses.include?(opt['value']) ? 'x' : ' '
      out += "\n  - [#{mark}] #{opt['label']} (value: '#{opt['value']}')"
    end
    out
  end
end

class DropdownQuestion < OptionsQuestion
  def render(response, index)
    out = "#{index}. #{@text} (dropdown question)#{print_visibility}"
    @options.each do |opt|
      mark = response == opt['value'] ? 'x' : ' '
      out += "\n  - <#{mark}> #{opt['label']} (value: '#{opt['value']}')"
    end
    out
  end
end