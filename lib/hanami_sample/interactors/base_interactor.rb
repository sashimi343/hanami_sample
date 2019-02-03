require 'hanami/interactor'

class HanamiSample::BaseInteractor
  include Hanami::Interactor

  def initialize(params = {})
    @params = params
  end

  def call()
    raise NotImplementedError.new("you must implement #{self.class}##{__method__}")
  end
end
