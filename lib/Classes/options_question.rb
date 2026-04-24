require_relative 'question'

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
