class FriendshipsController < ApplicationController
  include ApplicationHelper

  def show; end

  def edit
    reload_page
  end

  def create
    flash[:notice] = 'New friend added'
    p nf = current_user.add_friend(get_params[:friend_b_id])
    reload_page
  end

  def destroy
    p 'destroy time'
    flash[:notice] = 'Friend removed'
    #p current_user.friends
    # Friendship.where(friend_a_id: current_user.id, friend_b_id: get_params[:friend_b])  || Friendship.where(friend_a_id: get_params[:friend_b], friend_b_id: current_user.id)
    #p Friendship.where("friend_a_id = #{current_user.id} AND friend_b_id = #{get_params[:friend_b_id]} OR friend_a_id = #{get_params[:friend_b_id]} AND friend_b_id = #{current_user.id}")
    p current_user.remove_friend(get_params[:friend_b_id])
    reload_page
  end

  private

  def get_params
    params.fetch(:friendship, {}).permit(:friend_a_id, :friend_b_id)
  end

end
