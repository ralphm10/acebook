class FriendRequestsController < ApplicationController
  include ApplicationHelper

  def create
    p 'WE OUT HERE'
    reload_page
  end

end
