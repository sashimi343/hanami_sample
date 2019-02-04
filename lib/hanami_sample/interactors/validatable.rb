require 'hanami/validations'

module HanamiSample::Validatable
  class Validation
    include Hanami::Validations
  end

  def valid?()
    validation_result = Validation.new(@params).validate
    error(validation_result.messages) if validation_result.failure?

    validation_result.success?
  end
end
