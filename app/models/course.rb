class Course < ApplicationRecord
  belongs_to :instructor

  def to_s
    self.name
  end
end
