class FriendRequestsController < ApplicationController
  include ApplicationHelper

  # TODO: current_user.friend_requests ==> friend request objects similar to current_user.friends

  def create
    FriendRequest.create(requestor_id: current_user.id, receiver_id: get_params[:friend_b_id])
    flash[:notice] = user_b.first_name + ' has been added to friends' if current_user.check_friend_request_clash?
    reload_page
  end

  def accept
    current_user.accept_pending_friend_request(get_params[:friend_b_id])
    flash[:notice] = user_b.first_name + ' has been added to friends'
    reload_page
  end

  def remove_pending
    flash[:notice] = 'You have removed friend request to ' + user_b.first_name
    current_user.remove_pending_friend_request(get_params[:friend_b_id])
    reload_page
  end

  def delete
    current_user.reject_pending_friend_request(get_params[:friend_b_id])
    flash[:notice] = 'Request from ' + user_b.first_name + ' has been removed'
    reload_page
  end

  private

  def get_params
    params.fetch(:friend_request, {}).permit(:friend_a_id, :friend_b_id)
  end

  def user_b
    User.find(get_params[:friend_b_id])
  end

end
