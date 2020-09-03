class UsersController < ApplicationController

  def show
    current_user
  end

  def index
    @users = User.all
  end

  def new
    redirect_to '/posts' if current_user
    @friends = User.find(current_user.id).get_friends
    @users = User.all
  end

  def create
    err_code = User.validation_chain(get_params)
    flash[:danger] = 'Invalid email address' if err_code == 1
    flash[:danger] = 'First name is a required field' if err_code == 2
    flash[:danger] = 'Password must be between 6 and 10 characters' if err_code == 3
    flash[:danger] = 'Passwords do not match' if err_code == 4
    return go_to_registration_page if err_code

    @user = User.new(get_params)
    @user.save
    flash[:notice] = 'Successfully created user account'
    session[:id] = @user.id
    redirect_to '/posts'
  end

  private

  def get_params
    params.fetch(:user, {}).permit(:first_name, :last_name, :password, :password_confirmation, :email)
  end

end
