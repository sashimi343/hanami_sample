require_relative './application_error.rb'

module HanamiSample
  module Error
    class EntityNotFoundError < ApplicationError
      def initialize(name, errors = {})
        super("Requested #{name} not found", errors)
      end
    end
  end
end

