class User < ApplicationRecord
  has_many :posts, dependent: :destroy

  has_many :friendships, ->(user) { where('friend_a_id = ? OR friend_b_id = ?', user.id, user.id) }, dependent: :destroy

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
    return 4 unless password_match?(auth_params[:password], auth_params[:password_confirmation])
    nil
  end

  def self.email_valid?(email)
    email =~ EMAIL_FORMAT
  end

  def self.first_name_valid?(first_name)
    !first_name.empty?
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
      first_name: auth[:info][:name],
      password: 'mUc3m00R',
      password_confirmation: 'mUc3m00R'
    )
  end

  def self.password_valid?(password)
    password.length <= 10 && password.length >= 6
  end

  def self.password_match?(password, confirmation)
    password == confirmation
  end

  def friends
    Friendship.where('friend_a_id = ? OR friend_b_id = ?', id, id).map { |fs| fs.friend_a_id == id ? fs.friend_b : fs.friend_a }
  end

  def accept_friend

  end

end
