class Course < ApplicationRecord
  belongs_to :instructor
  has_many :subscribers
  has_many :users, through: :subscribers

  def to_s
    self.name
  end
end
