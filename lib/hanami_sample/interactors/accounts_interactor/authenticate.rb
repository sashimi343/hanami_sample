require 'hanami/interactor'
require_relative '../validatable_interactor.rb'

module AccountsInteractor
  class Authenticate < HanamiSample::ValidatableInteractor
    expose :authenticated_user

    class Validation
      include Hanami::Validations

      validations do
        required(:screen_name) { filled? }
        required(:password) { filled? }
      end
    end

    def initialize(params = {}, user_repository = UserRepository.new, account_repository = AccountRepository.new)
      @user_repository = user_repository
      @account_repository = account_repository
      super(params)
    end

    def call()
      account = @account_repository.find_by_screen_name(@params[:screen_name])

      error!("account not found") if account.nil?
      error!("password is incorrect") unless account.authenticate(@params[:password])

      @authenticated_user = @user_repository.find(account.user_id)
    end
  end
end
