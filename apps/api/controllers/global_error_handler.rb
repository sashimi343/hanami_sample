module Web
  module GlobalErrorHandler

    def self.included(action)
      action.class_eval do
        handle_exception HanamiSample::Error::ValidationError => :handle_validation_error
        handle_exception HanamiSample::Error::UnprocessableEntityError => :handle_unprocessable_entity_error
        handle_exception HanamiSample::Error::AuthenticationError => :handle_authentication_error
        handle_exception HanamiSample::Error::EntityNotFoundError => :handle_entity_not_found_error
        handle_exception HanamiSample::Error::ParameterInvalidError => :handle_entity_not_found_error
        handle_exception RuntimeError => :handle_runtime_error
      end
    end

    private

    def handle_validation_error(error)
      write_debug_log(error)
      halt_with_error(400, error)
    end

    def handle_unprocessable_entity_error(error)
      write_debug_log(error)
      halt_with_error(422, error)
    end

    def handle_authentication_error(error)
      write_debug_log(error)
      halt_with_error(403, error)
    end

    def handle_entity_not_found_error(error)
      write_debug_log(error)
      halt_with_error(404, error)
    end

    def handle_runtime_error(error)
      write_warning(error)
      halt 500, error_response(error.message)
    end

    def halt_with_error(status, error)
      halt status, error_response(error.message, error.errors)
    end

    def error_response(message, errors = {})
      JSON.generate({ message: message, errors: errors })
    end

    def write_debug_log(error)
      Hanami.logger.debug("[#{self.class.name}] #{error.message} (#{error.errors})")
    end

    def write_warning(error)
      Hanami.logger.warn("[#{self.class.name}] #{error.message} (#{error.errors}) #{error.backtrace.join('\\n')}")
    end
  end
end
