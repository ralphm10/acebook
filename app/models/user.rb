class User < ApplicationRecord
  has_many :posts, dependent: :destroy

  has_many :friend_requests, dependent: :destroy
  has_many :friend_requests_as_requestor,
           foreign_key: :requestor_id,
           class_name: 'FriendRequest',
           dependent: :destroy
  has_many :friend_requests_as_receiver,
           foreign_key: :receiver_id,
           class_name: 'FriendRequest',
           dependent: :destroy

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

  def already_friends_with?(user)
    friends.include?(user)
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

  def add_friend(new_friend_id)
    Friendship.create(friend_a_id: id, friend_b_id: new_friend_id)
  end

  def remove_friend(new_friend_id)
    return p 'Friendship does not exist' unless friends.include?(User.find(new_friend_id))

    friendship = Friendship.where("friend_a_id=#{id} AND friend_b_id=#{new_friend_id}")
    friendship = Friendship.where("friend_a_id=#{new_friend_id} AND friend_b_id=#{id}") unless friendship.first
    Friendship.destroy(friendship.first[:id])
  end

  def friend_request_for?(user_id)
    friend_requests_as_requestor.map { |req| return true if req.receiver_id == user_id }
    false
  end

  def friend_request_from?(user_id)
    friend_requests_as_receiver.map { |req| return true if req.requestor_id == user_id }
    false
  end

  def pending_friend_request?(user_id)
    friend_request = FriendRequest.where("requestor_id=#{id} AND receiver_id=#{user_id}")
    friend_request = FriendRequest.where("receiver_id=#{user_id} AND requestor_id=#{id}") unless friend_request.first
    friend_request ? true : false
  end

  def accept_pending_friend_request(user_id)
    destroy_pending_requests_from(user_id)
    add_friend(user_id)
  end

  def reject_pending_friend_request(user_id)
    destroy_pending_requests_from(user_id)
  end

  def remove_pending_friend_request(user_id)
    return if FriendRequest.where("receiver_id=#{id} AND requestor_id=#{user_id}").first.nil? &&
              FriendRequest.where("receiver_id=#{user_id} AND requestor_id=#{id}").first.nil?
    FriendRequest.destroy(FriendRequest.where("receiver_id=#{user_id} AND requestor_id=#{id}").first.id)
  end

  def check_friend_request_clash?
    # TODO: Work on this one.
    p 'checking friend request clash'
    #p friend_request_from?(user_id)
    #p friend_request_for?(user_id)
    friend_requests_as_receiver.map{ |friend_request|
      other_user = User.find(friend_request.requestor_id)
      other_user.friend_requests_as_receiver.map{ |other_user_friend_request|
        if other_user_friend_request.requestor_id == id
          accept_pending_friend_request(other_user_friend_request.receiver_id)
          other_user.reject_pending_friend_request(id)
          return true
        end
      }
    }
    p false
  end

  private

  def destroy_pending_requests_from(user_id)
    FriendRequest.destroy(FriendRequest.where("receiver_id=#{id} AND requestor_id=#{user_id}").first.id)
  end

end
