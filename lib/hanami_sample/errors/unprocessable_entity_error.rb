require_relative './application_error.rb'

module HanamiSample
  module Error
    class UnprocessableEntityError < ApplicationError
      def initialize(entity, errors = {})
        super("An error has occurred while processing #{entity}", errors)
      end
    end
  end
end
