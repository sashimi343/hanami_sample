module Api
  module Controllers
    module Sessions
      class Login
        include Api::Action

        expose :authenticated_user

        def call(params)
          interactor = AccountsInteractor::Authenticate.new(params)
          result = interactor.call

          raise HanamiSample::Error::AuthenticationError.new(result.errors) if result.failure?

          @authenticated_user = result.authenticated_user
          session[:current_user] = @authenticated_user
        end
      end
    end
  end
end
