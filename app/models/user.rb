class User < ActiveRecord::Base
  before_save :default_value

  validates :username, length: { minimum: 5, maximum: 20 }, uniqueness: true
  validates :password, length: { minimum: 8, maximum: 20 }

  def default_value
    self.count ||= 1
  end
end
