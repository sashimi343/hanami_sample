require 'bcrypt'

class Account < Hanami::Entity
  def initialize(attributes = {})
    if attributes.has_key? :password
      super attributes.merge(
        password_digest: BCrypt::Password.create(attributes[:password])
      )
    else
      super attributes
    end
  end

  def password()
    BCrypt::Password.new(password_digest)
  end
end

