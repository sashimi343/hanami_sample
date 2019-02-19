class AccountRepository < Hanami::Repository
  def create_with_password_encryption(params)
    account = Account.new(params)
    create(
      screen_name: account.screen_name,
      password_digest: account.password,
      user_id: account.user_id
    )
  end

  def find_by_screen_name(screen_name)
    accounts.where(screen_name: screen_name).first
  end

  def find_by_user_id(user_id)
    accounts.where(user_id: user_id).first
  end
end
