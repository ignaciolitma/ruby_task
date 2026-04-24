require_relative 'question'

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