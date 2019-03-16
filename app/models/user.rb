class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :role

  def to_s
    {
      :id           => self.id,
      :email        => self.email,
      :role         => self.role.name,
      :institute_id => self.instituteid,
    }.to_s
  end
end
