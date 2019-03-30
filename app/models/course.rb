class Course < ApplicationRecord
  belongs_to :instructor
  has_many :subscribers
  has_many :groups
  has_many :users, through: :subscribers

  validate :check_dates

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

  def in_training_period? now
    if self.end_date.nil?
      return true
    end
    now >= self.start_date and now <= self.end_date
  end

  private

  def check_dates
    if self.start_date > self.end_date
      errors.add(:course, 'Start date can\'t be after end date.')
    end
  end
end
