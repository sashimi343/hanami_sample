class AccountRepository < Hanami::Repository
  def create_with_password_encryption(params)
    account = Account.new(params)
    create(
      screen_name: account.screen_name,
      password_digest: account.password,
      user_id: account.user_id
    )
  end
end
