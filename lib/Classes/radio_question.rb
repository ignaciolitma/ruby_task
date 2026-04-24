require_relative 'options_question'

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