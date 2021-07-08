class User < ApplicationRecord
  has_many :comments
  EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  validates :email, :password, :password_confirmation, presence: true
  validates :email, :presence => true, :uniqueness => true
  has_secure_password
end
