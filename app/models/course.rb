class Course < ApplicationRecord
  belongs_to :instructor
  has_many :subscribers, :dependent => :destroy
  has_many :groups, :dependent => :destroy
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

  def group(user)
    if self.subscribed? user
      return self.subscribers.where(user: user).take.group
    else
      return nil
    end
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
