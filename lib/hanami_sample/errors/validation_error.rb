require_relative './application_error.rb'

module HanamiSample
  module Error
    class ValidationError < ApplicationError
      def initialize(errors = {})
        super("Parameter is invalid", errors)
      end
    end
  end
end
