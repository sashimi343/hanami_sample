require 'hanami/validations'
require_relative '../validatable_interactor.rb'

module AccountsInteractor
  class Register < HanamiSample::ValidatableInteractor
    expose :user
    expose :account

    class Validation
      include Hanami::Validations

      predicate :unused_email?, message: "is already used" do |current|
        UserRepository.new.find_by_email(current).nil?
      end

      predicate :unused_screen_name?, message: "is already used" do |current|
        AccountRepository.new.find_by_screen_name(current).nil?
      end

      validations do
        required(:name) { filled? }
        required(:email) { filled? and unused_email? }
        required(:screen_name) { filled? and unused_screen_name? }
        required(:password) { filled? }
      end
    end

    def initialize(params = {}, user_repository = UserRepository.new, account_repository = AccountRepository.new)
      @user_repository = user_repository
      @account_repository = account_repository

      super(params)
    end

    def call()
      @user = @user_repository.create(name: @params[:name], email: @params[:email])
      @account = @account_repository.create_with_password_encryption(
        screen_name: @params[:screen_name],
        password: @params[:password],
        user_id: @user.id
      )
    end
  end
end
