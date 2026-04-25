require 'yaml'
require 'json-schema'
require 'optparse'
require_relative 'Classes/question.rb'

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

    # Use .select to filter and only attempt to merge dictionaries
    flat_responses = responses.values.select { |v| v.is_a?(Hash) }.reduce({}, :merge) || {}

    @questions.each do |q|
      if q.visible?(flat_responses)
        # 1. First we generate the text and store it instead of printing directly
        rendered_question = q.render(form_responses[q.id], index)

        # 2. We check that the text is not null or empty before printing
        if rendered_question && !rendered_question.to_s.strip.empty?
          puts rendered_question
          puts ""
          index += 1 # We only increment if it was actually shown on screen
        end
      end
    end
  end
end


## Validation of JSON Schema and CLI handling
if __FILE__ == $0
  options = {}
  OptionParser.new do |opts|
    opts.on("--config c1,c2", Array) { |v| options[:configs] = v }
    opts.on("--responses r") { |v| options[:responses] = v }
  end.parse!

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
    JSON::Validator.validate!(schema, config) # Throw error if is invalid
    questionnaire = Questionnaire.new(config)
    questionnaire.print(responses)
  end
end