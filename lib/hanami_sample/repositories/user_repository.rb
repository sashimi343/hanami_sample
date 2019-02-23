class UserRepository < Hanami::Repository
  associations do
    has_many :tasks
  end

  def find_by_email(email)
    users.where(email: email).first
  end

  def find_with_books(id)
    aggregate(:tasks).where(id: id).as(User).first
  end

  def add_task(user, data)
    assoc(:tasks, user).add(data)
  end
end
