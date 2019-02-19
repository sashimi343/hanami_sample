require 'hanami/validations'
require_relative '../validatable_interactor.rb'

module ProfilesInteractor
  class Show < HanamiSample::ValidatableInteractor
    class Validation
      include Hanami::Validations

      validations do
        required(:user_id) { filled? and int? }
      end
    end

    expose :user, :account

    def initialize(params = {}, user_repository = UserRepository.new, account_repository = AccountRepository.new)
      @user_repository = user_repository
      @account_repository = account_repository
      super(params)
    end

    def call()
      @user = @user_repository.find(@params[:user_id])
      error!("user not found") if @user.nil?

      @account = @account_repository.find_by_user_id(@params[:user_id])
      error!("account not found") if @account.nil?
    end
  end
end
