class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def new; end

  def create
    if auth_hash
      return flash[:notice] =
      'Your email address must be publicly visible to use OAuth services' if auth_hash[:info][:email].nil?
      user = User.sign_in_from_omniauth(auth_hash)
      session[:id] = user.id
      return redirect_to '/posts'
    end
    @user = User.find_by(email: params[:session][:email])
    if @user&.authenticate(params[:session][:password])
      session[:id] = @user.id
      redirect_to '/posts'
    else
      flash.now[:danger] = 'Please check the information submitted'
      render 'new'
    end
  end



  def destroy
    session.delete(:omniauth)
    session.delete(:id)
    @current_user = nil
    session[:omniauth] = nil
    redirect_to '/'
  end

  private

  def auth_hash
    session[:omniauth] = request.env['omniauth.auth']
  end

end
