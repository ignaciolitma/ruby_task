require_relative 'question'

class BooleanQuestion < Question
  def render(response, index)
    out = "#{index}. #{@text} (boolean question)#{print_visibility}"
    out += "\n   - (#{response == true ? 'x' : ' '}) Yes (value: true)"
    out += "\n   - (#{response == false ? 'x' : ' '}) No (value: false)"
    out
  end
end