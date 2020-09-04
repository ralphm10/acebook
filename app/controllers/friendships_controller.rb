class FriendshipsController < ApplicationController
  include ApplicationHelper

  def show; end

  def edit
    reload_page
  end

  def create
    flash[:notice] = 'New friend added'
    current_user.add_friend(get_params[:friend_b_id])
    reload_page
  end

  def destroy
    flash[:notice] = 'Friend removed'
    current_user.remove_friend(get_params[:friend_b_id])
    reload_page
  end

  private

  def get_params
    params.fetch(:friendship, {}).permit(:friend_a_id, :friend_b_id)
  end
end
