class CheckboxQuestion < OptionsQuestion
  def initialize(config)
    super
    @options << { 'label' => 'Other', 'value' => '_' } if config['allow_other']
    @options << { 'label' => 'None of the above', 'value' => 'none_of_the_above' } if config['allow_none_of_the_above']
  end
  
  def render(response, index)
    responses = response || []
    selected_ids = responses.map { |r| r.is_a?(Hash) ? r.keys.first.to_s : r.to_s }

    out = "#{index}. #{@text} (checkbox question)#{print_visibility}"
    @options.each do |opt|
      val = opt['value'].to_s
      mark = selected_ids.include?(val) ? 'x' : ' '
      
      out += "\n  - [#{mark}] #{opt['label']} (value: '#{val}')"
      
      if val == '_' && (typed = responses.find { |r| r.is_a?(Hash) && r.key?('_') })
        out += "\n      > User typed: \"#{typed['_']}\""
      end
    end
    out
  end
end