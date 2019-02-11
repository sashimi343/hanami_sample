module HanamiSample
  module Error
    class ApplicationError < StandardError
      def initialize(message, errors = {})
        @errors = errors
        super(message)
      end

      def errors()
        @errors.dup
      end
    end
  end
end

