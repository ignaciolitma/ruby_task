require_relative 'question'

class TextQuestion < Question
  def initialize(config)
    super
    @min = config['min_length']
    @max = config['max_length']
  end

  def render(response, index)
    out = "#{index}. #{@text} (text question)"
    limits = []
    limits << "at least <#{@min}> characters" if @min
    limits << "at most <#{@max}> characters" if @max
    out += "\n   You can enter #{limits.join(' and ')}." unless limits.empty?
    out += print_visibility
    
    if response && !response.to_s.empty?
      out += "\n   > Answer: #{response}"
    end
    out
  end
end