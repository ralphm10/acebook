class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :require_login

  def current_user
    @current_user ||= User.find_by(id: session[:id])
  end

  helper_method :current_user

  private

    def require_login
      unless current_user
        redirect_to '/users/new'
      end
    end

end
