module Api
  module Controllers
    module Profile
      class Index
        include Api::Action

        before :authenticate!
        expose :user, :account

        def call(params)
          interactor = ProfilesInteractor::Show.new(user_id: @current_user.id)
          result = interactor.call

          raise HanamiSample::Error::ParameterInvalidError.new(result.errors) if interactor.validation_failed?

          @user = result.user
          @account = result.account

          raise HanamiSample::Error::EntityNotFoundError.new("user", result.errors) if @user.nil?
        end
      end
    end
  end
end
