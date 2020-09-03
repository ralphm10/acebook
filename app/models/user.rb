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

  def self.sign_in_from_omniauth(auth)
    find_by(email: auth[:info][:email],
            provider: auth[:provider],
            uid: auth[:uid],
            first_name: auth[:info][:name]) || create_user_from_omniauth(auth)
  end

  def self.create_user_from_omniauth(auth)
    create(
      email: auth[:info][:email],
      provider: auth[:provider],
      uid: auth[:uid],
      first_name: auth[:info][:name]
    )
  end

end
