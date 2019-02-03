require_relative '../base_interactor.rb'

module AccountsInteractor
  class Register < ::BaseInteractor
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
