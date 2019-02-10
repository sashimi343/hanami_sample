require_relative '../base_interactor.rb'
require_relative '../validatable.rb'

module AccountsInteractor
  class Register < HanamiSample::BaseInteractor
    include HanamiSample::Validatable

    Validation.class_eval do
      validations do
        required(:name) { filled? }
        required(:email) { filled? }
        required(:screen_name) { filled? }
        required(:password) { filled? }
      end
    end

    def initialize(params = {}, user_repository: UserRepository.new, account_repository: AccountRepository.new)
      @user_repository = user_repository
      @account_repository = account_repository

      super(params)
    end

    def call()
      user = @user_repository.create(name: @params[:name], email: @params[:email])
      account = @account_repository.create_with_password_encryption(
        screen_name: @params[:screen_name],
        password: @params[:password],
        user_id: user.id
      )

      user
    end
  end
end
