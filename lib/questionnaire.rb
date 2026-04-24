require 'yaml'
require 'json-schema'
require 'optparse'
require_relative 'Classes/question.rb'


# --- FORM BUILDER Y RENDERIZADOR ---
class Questionnaire
  attr_reader :id, :title

  def initialize(config)
    @id = config['id']
    @title = config['title']
    @questions = config['questions'].map { |q_config| Question.build(q_config) }
  end

  def print(responses)
    puts "**#{@title.upcase}**\n\n"
    index = 1
    form_responses = responses[@id] || {}
    flat_responses = responses.values.reduce({}, :merge) # Para condiciones cruzadas

    @questions.each do |q|
      if q.visible?(flat_responses)
        puts q.render(form_responses[q.id], index)
        puts ""
        index += 1
      end
    end
  end
end

# --- CLI & VALIDACIÓN SCHEMA (BONUS) ---
if __FILE__ == $0
  options = {}
  OptionParser.new do |opts|
    opts.on("--config c1,c2", Array) { |v| options[:configs] = v }
    opts.on("--responses r") { |v| options[:responses] = v }
  end.parse!

  # Bonus: JSON Schema simple
  schema = {
    "type" => "object",
    "required" => ["id", "title", "questions"],
    "properties" => {
      "id" => { "type" => "string" },
      "title" => { "type" => "string" },
      "questions" => { "type" => "array" }
    }
  }

  responses = YAML.load_file(options[:responses])

  options[:configs].each do |file|
    config = YAML.load_file(file)
    JSON::Validator.validate!(schema, config) # Lanza error si es inválido
    questionnaire = Questionnaire.new(config)
    questionnaire.print(responses)
  end
end