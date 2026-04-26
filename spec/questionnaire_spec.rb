require 'rspec'
require 'yaml'
require_relative '../lib/questionnaire'

RSpec.describe Questionnaire do
  let(:config) do
    {
      'id' => 'test_form',
      'title' => 'Test',
      'questions' => [
        { 'id' => 'q1', 'type' => 'boolean', 'text' => 'Live in US?' },
        { 
          'id' => 'q2', 'type' => 'text', 'text' => 'State?',
          'condition' => { 'type' => 'value', 'question_id' => 'q1', 'value' => true }
        }
      ]
    }
  end

  let(:questionnaire) { Questionnaire.new(config) }

  describe '#print' do
    it 'shows the question if the condition is true' do
      responses_true = { 'test_form' => { 'q1' => true }, 'q1' => true }
      responses_false = { 'test_form' => { 'q1' => false }, 'q1' => false }

      expect { questionnaire.print(responses_true) }.to output(/State\?/).to_stdout
      expect { questionnaire.print(responses_false) }.not_to output(/State\?/).to_stdout
    end
  end
end

RSpec.describe Questionnaire do
  let(:config) { YAML.load_file('exhaustive_form.yaml') }
  let(:questionnaire) { Questionnaire.new(config) }
  describe '#print' do
    context 'Case 1: Empty form (without responses)' do
      let(:responses) { {} }

      it 'Print only tha root question and keep correlative index' do
        # Capturamos la out de la consola
        out = capture_stdout { questionnaire.print(responses) }

        # Verificamos que las preguntas base existen
        expect(out).to include("1. What is your full name?")
        expect(out).to include("2. Do you program in Ruby?")
        expect(out).to include("3. Are you a Senior Developer?")
        
        # Verificamos que las preguntas condicionales NO existen
        expect(out).not_to include("Which Ruby frameworks do you use?")
        expect(out).not_to include("What advice would you give to juniors?")
      end
    end

    context 'Case 2: True condition (uses_ruby = true)' do
      let(:responses) do
        {
          'dev_survey' => {
            'uses_ruby' => true,
            'is_senior' => false
          }
        }
      end

      it 'Shows conditional question and update correctly index' do
        out = capture_stdout { questionnaire.print(responses) }

        expect(out).to include("3. Which Ruby frameworks do you use?")
        expect(out).to include("<Visible> Do you program in Ruby?: true")
        
        expect(out).to include("4. Are you a Senior Developer?")
        
        expect(out).not_to include("What advice would you give to juniors?")
      end
    end

    context 'Case 4: AND Composed condition (ruby = true, senior = true)' do
      let(:responses) do
        {
          'dev_survey' => {
            'uses_ruby' => true,
            'is_senior' => true,
            'senior_advice' => 'Always write unit test.'
          }
        }
      end

      it 'Show all question and render the AND\' tag' do
        out = capture_stdout { questionnaire.print(responses) }

        expect(out).to include("5. What advice would you give to juniors?")
        
        expect(out).to include("<AND Visible> Do you program in Ruby?: true")
        expect(out).to include("<AND Visible> Are you a Senior Developer?: true")
        
        expect(out).to include("> Answer: Always write unit test.")
      end
    end

    context 'Case 5: Checkbox with "Other" answer' do
      let(:responses) do
        {
          'dev_survey' => {
            'uses_ruby' => true,
            'ruby_frameworks' => [
              'rails',
              { '_' => 'Hanami' }
            ]
          }
        }
      end

      it 'Shows all the right options and print "Other" value' do
        out = capture_stdout { questionnaire.print(responses) }

        expect(out).to include("- [x] Ruby on Rails (value: 'rails')")
        expect(out).to include("- [ ] Sinatra (value: 'sinatra')")
        expect(out).to include("- [x] Other (value: '_')")
        expect(out).to include("> User typed: \"Hanami\"")
      end
    end
  end

  def capture_stdout
    original_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = original_stdout
  end
end