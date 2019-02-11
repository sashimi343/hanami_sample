require 'hanami/validations'

module HanamiSample::Validatable
  class Validation
    include Hanami::Validations
  end

  def valid?()
    validation_result = Validation.new(@params).validate

    if validation_result.failure? and !@validation_failed
      error(validation_result.messages)
      @validation_failed = true
    end

    validation_result.success?
  end

  def validation_failed?
    @validation_failed
  end
end
