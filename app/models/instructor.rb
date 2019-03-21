class Instructor < ApplicationRecord
  belongs_to :user
  belongs_to :department

  def to_s
    {
      :id => self.id,
      :department => self.department.name,
      :user => self.user.to_s
    }.to_s
  end
end
