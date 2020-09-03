class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def go_to_registration_page
    redirect_to '/users/new'
  end

  def current_user
    @current_user ||= User.find_by(id: session[:id])
  end

  helper_method :current_user, :go_to_registration_page

  private

  def require_login
    redirect_to login_url unless current_user
  end

end
