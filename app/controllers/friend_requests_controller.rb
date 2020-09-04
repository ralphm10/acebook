class FriendRequestsController < ApplicationController
  include ApplicationHelper

  # TODO: current_user.friend_requests ==> friend request objects similar to current_user.friends

  def create
    p FriendRequest.create(requestor_id: current_user.id, receiver_id: get_params[:friend_b_id])
    reload_page
  end

  def accept
    current_user.accept_pending_friend_request(get_params[:friend_b_id])
    flash[:notice] = User.find(get_params[:friend_b_id]).first_name.to_s + ' has been added to friends'
    reload_page
  end

  def delete
    p current_user.reject_pending_friend_request(get_params[:friend_b_id])
    reload_page
  end

  private

  def get_params
    params.fetch(:friend_request, {}).permit(:friend_a_id, :friend_b_id)
  end

end
