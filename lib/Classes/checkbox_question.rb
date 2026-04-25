class CheckboxQuestion < OptionsQuestion
  def initialize(config)
    super
    @options << { 'label' => 'Other', 'value' => '_' } if config['allow_other']
    @options << { 'label' => 'None of the above', 'value' => 'none_of_the_above' } if config['allow_none_of_the_above']
  end
  
  def render(response, index)
    responses = response || []
    out = "#{index}. #{@text} (checkbox question)#{print_visibility}"
    
    @options.each do |opt|
      # Cambiamos la lógica de marcado:
      # Marcamos con 'x' si el valor está directo O si existe un hash que tenga ese valor como clave
      is_selected = responses.include?(opt['value']) || responses.any? { |r| r.is_a?(Hash) && r.key?(opt['value']) }
      mark = is_selected ? 'x' : ' '
      
      out += "\n  - [#{mark}] #{opt['label']} (value: '#{opt['value']}')"
      
      if opt['value'] == '_' && (typed = responses.find { |r| r.is_a?(Hash) && r.key?('_') })
        out += "\n      > User typed: \"#{typed['_']}\""
      end
    end
    out
  end
end