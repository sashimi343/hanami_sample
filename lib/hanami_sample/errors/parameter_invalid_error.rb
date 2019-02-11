require_relative './application_error.rb'

module HanamiSample
  module Error
    class ParameterInvalidError < ApplicationError
      def initialize(errors = {})
        super("request parameter is invalid", errors)
      end
    end
  end
end

