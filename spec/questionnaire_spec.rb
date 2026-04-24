require 'rspec'
require_relative '../questionnaire'

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
    it 'muestra la pregunta condicional solo si se cumple la condición' do
      responses_true = { 'test_form' => { 'q1' => true }, 'q1' => true }
      responses_false = { 'test_form' => { 'q1' => false }, 'q1' => false }

      expect { questionnaire.print(responses_true) }.to output(/State\?/).to_stdout
      expect { questionnaire.print(responses_false) }.not_to output(/State\?/).to_stdout
    end
  end
end