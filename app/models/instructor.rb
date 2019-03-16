class Instructor < ApplicationRecord
  belongs_to :user
  belongs_to :department

  def to_s
    {
      :id => self.id,
      :email => self.user.email,
      :instructor_id => self.user.instituteid,
      :department => self.department.name
    }.to_s
  end
end
