class Group < ApplicationRecord
  belongs_to :course
  has_many :subscribers, :dependent => :nullify

  has_one_attached :project

  def has_user?(user)
    self.subscribers.where(user: user).count >= 1
  end
end
