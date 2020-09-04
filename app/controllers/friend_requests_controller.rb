class FriendRequestsController < ApplicationController
  include ApplicationHelper

  def create
    p FriendRequest.create(requestor_id: current_user.id, receiver_id: get_params[:friend_b_id])
    reload_page
  end

  def delete
    p get_params[:friend_a_id]
  end

  private

  def get_params
    params.fetch(:friend_request, {}).permit(:friend_a_id, :friend_b_id)
  end

end
