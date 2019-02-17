require 'hanami/validations'
require_relative './base_interactor.rb'

class HanamiSample::ValidatableInteractor < HanamiSample::BaseInteractor
  def initialize(params = {})
    @validation_class = Object.const_get(self.class.name).const_get("Validation")
    super(params)
  end

  def valid?()
    validation_result = @validation_class.new(@params).validate

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
