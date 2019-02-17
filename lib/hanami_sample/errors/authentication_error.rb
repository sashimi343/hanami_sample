module HanamiSample::Error
  class AuthenticationError < ApplicationError
    def initialize(errors = {})
      super("Authentication failed", errors)
    end
  end
end
