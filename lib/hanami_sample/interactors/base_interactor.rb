require 'hanami/interactor'
require 'hanami/validations'

class HanamiSample::BaseInteractor
  include Hanami::Interactor

  class Validation
    include Hanami::Validations
  end

  def initialize(params = {})
    @params = params
  end

  def call()
    raise NotImplementedError.new("you must implement #{self.class}##{__method__}")
  end

  private

  def self.validator(&block)
    Validation.class_eval do
      validations block
    end
  end

  def valid?()
    validation_result = Validation.new(@params).validate
    error(validation_result.messages) if validation_result.failure?

    validation_result.success?
  end
end
