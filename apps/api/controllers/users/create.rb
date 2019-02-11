module Api
  module Controllers
    module Users
      class Create
        include Api::Action

        expose :user, :account

        def call(params)
          interactor = AccountsInteractor::Register.new(params)
          result = interactor.call

          if interactor.validation_failed?
            raise HanamiSample::Error::ValidationError.new(result.errors)
          end

          if result.successful?
            @user = result.user
            @account = result.account
          else
            raise HanamiSample::Error::UnprocessableEntityError.new("user", result.errors)
          end
        end
      end
    end
  end
end
