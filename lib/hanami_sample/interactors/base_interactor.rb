require 'hanami/interactor'

class BaseInteractor
  include Hanami::Interactor

  @@validators = []

  def initialize(params = {})
    @params = params
  end

  def call()
    raise NotImplementedError.new("you must implement #{self.class}##{__method__}")
  end

  private

  def self.validator(validator)
    @@validators << validator
  end

  def valid?()
    validation_success = true

    @@validators.each do |validator|
      validation_result = validator.new(@params).validate

      if validation_result.failure?
        validation_success = false
        error(validation_result.message)
      end
    end

    validation_success
  end
end
