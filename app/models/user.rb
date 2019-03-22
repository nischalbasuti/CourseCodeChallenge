class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :role
  has_many :subscribers
  has_many :courses, through: :subscribers

  validate :validate_fields, :check_username_exists

  def check_username_exists
    if User.where(username: self.username).count >= 1
      errors.add(:user, "username #{self.username} already exists")
    end
  end

  def validate_fields

    # first_name, last_naem, instituteid, citizenid.
    if self.first_name.blank?
      errors.add(:user, 'invalid first name.')
    end
    if self.last_name.blank?
      errors.add(:user, 'invalid last name.')
    end
    if self.citizenid.blank?
      errors.add(:user, 'invalid citizen ID.')
    end

    if self.instructor? or self.student?
      if self.instituteid.blank?
        errors.add(:user, 'invalid student ID / instructor ID.')
      end
    end
  end

  def instructor?
    if self.role.nil?
      return nil
    end
    self.role.name == "instructor"
  end
  def student?
    if self.role.nil?
      return nil
    end
    self.role.name == "student"
  end
  def other?
    if self.role.nil?
      return nil
    end
    self.role.name == "other"
  end

  def instructor_of?(course)
    if not self.instructor?
      return false
    end

    if course.instructor.user.id == self.id
      return true
    end
    false
  end

  # email_required? and will_save_change_to_email? need to be defined when using
  # the validatable module.
  # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-with-something-other-than-their-email-address
  def email_required?
    false
  end
  def will_save_change_to_email?
    false
  end

  def to_s
    {
      :id           => self.id,
      :username     => self.username,
      :first_name   => self.first_name,
      :last_name    => self.last_name,
      :role         => self.role.name,
      :institute_id => self.instituteid,
    }.to_s
  end
end
