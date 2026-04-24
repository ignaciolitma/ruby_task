require_relative 'questionnaire' # Carga las clases que ya creamos

# 1. Instanciamos los cuestionarios desde su configuración
personal_config = YAML.load_file('personal_information.yaml')
situation_config = YAML.load_file('about_the_situation.yaml')

questionnaire_personal = Questionnaire.new(personal_config)
questionnaire_situation = Questionnaire.new(situation_config)

# 2. El payload exacto del requerimiento
user_response = {
  'personal_information' => {
    'name' => 'Ubba Huang',
    'have_alias' => true
  },
  'about_the_situation' => {
    'which_situation' => 'sa',
    'live_in_us' => false
  }
}

# 3. Consumo de la API (Imprime el cuestionario dinámicamente)
questionnaire_personal.print(user_response)
questionnaire_situation.print(user_response)