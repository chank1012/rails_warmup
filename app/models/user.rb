class User < ActiveRecord::Base
  before_save :default_value

  validate :check_username
  validate :check_password

  validates_uniqueness_of :username

  #validates :username, length: { minimum: 5, maximum: 20 }, uniqueness: true
  #validates :password, length: { minimum: 8, maximum: 20 }

  def default_value
    self.count ||= 1
  end

  def check_username
    errors.add(:username, :invalid_length) if username.length < 5 or username.length > 20
  end

  def check_password
    errors.add(:password, :invalid_length) if password.length < 8 or password.length > 20
  end
end
