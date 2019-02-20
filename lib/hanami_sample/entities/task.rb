class Task < Hanami::Entity
  def overdue?()
    deadline && deadline <= Time.now
  end

  def done?()
    closed_at && closed_at <= Time.now
  end
end
