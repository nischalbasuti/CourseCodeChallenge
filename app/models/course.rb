class Course < ApplicationRecord
  belongs_to :instructor
  has_many :subscribers
  has_many :users, through: :subscribers

  def subscribed?(user)
    self.users.where(id: user.id).count >= 1
  end

  def instructor?(user)
    if self.instructor.user == user
      return true
    end
    return false
  end

  def subscribe(user)
    if not self.subscribed? user
      self.users << user
    end
  end

  def unsubscribe(user)
    self.subscribers.where(user: user).destroy_all
  end


  def to_s
    self.name
  end
end
