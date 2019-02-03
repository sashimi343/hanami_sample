require_relative '../validatable_interactor.rb'

module AccountsInteractor
  class Register < HanamiSample::ValidatableInteractor
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
      # your code goes here
    end
  end
end
