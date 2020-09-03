class User < ApplicationRecord
  has_many :posts, dependent: :destroy

  validates :first_name, presence: true
  EMAIL_FORMAT = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :password, length: { in: 6..10 }
  validates :email, presence: true, format: { with: EMAIL_FORMAT }, uniqueness: true
  before_save { self.email = email.downcase }
  has_secure_password

  def comments
    count = 0
    Comment.all.map { |comment| count += 1 if comment.poster.to_i == id }
    count
  end

  def self.validation_chain(auth_params)
    return 1 unless email_valid?(auth_params[:email])
    return 2 unless first_name_valid?(auth_params[:first_name])
    return 3 unless password_valid?(auth_params[:password])
    nil
  end

  def self.email_valid?(email)
    email =~ EMAIL_FORMAT
  end

  def self.first_name_valid?(first_name)
    !first_name.empty?
  end

  def self.password_valid?(password)
    password.length <= 10 && password.length >= 6
  end

end
