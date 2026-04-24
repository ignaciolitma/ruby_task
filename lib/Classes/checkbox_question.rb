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