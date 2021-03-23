class RootContract < Dry::Validation::Contract
  config.messages.backend = :i18n

  def self.validate_input(input)
    new.validate_input(input)
  end

  def validate_input(input)
    Operations::ValidateInput.call(input, contract_klass: self.class)
  end
end
