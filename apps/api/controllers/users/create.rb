module Api
  module Controllers
    module Users
      class Create
        include Api::Action

        expose :user
        expose :account
        expose :errors

        def call(params)
          result = AccountsInteractor::Register.new(params).call

          if result.successful?
            @user = result.user
            @account = result.account
          else
            self.status = 400
            @errors = result.errors
          end
        end
      end
    end
  end
end
