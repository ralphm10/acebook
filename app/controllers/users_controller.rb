class UsersController < ApplicationController

  def show
    current_user
  end

  def new
    redirect_to '/posts' if current_user
    @user = User.new
  end

  def create
    err_code = User.validation_chain(get_params)
    flash[:danger] = 'Invalid email' if err_code == 1
    flash[:danger] = 'First name is a required field' if err_code == 2
    return go_to_registration_page if err_code

    @user = User.new(get_params)
    @user.save
    flash[:notice] = 'Successfully created user account'
    session[:id] = @user.id
    redirect_to '/posts'

    #if !User.email_valid?(get_params[:email])
    #  flash[:danger] = 'Invalid email'
    # go_to_registration_page
    #elsif get_params[:first_name].empty?
    # flash[:danger] = 'First name is a required field'
    # go_to_registration_page
    #elsif !@user.created_at
    # flash[:danger] = 'Please check submitted information'
    # go_to_registration_page
    #elsif @user.created_at
    # @user.save
    #  flash[:notice] = 'Successfully created user account'
    # session[:id] = @user.id
    # redirect_to '/posts'
    #end
  end

  private

  def get_params
    params.fetch(:user, {}).permit(:first_name, :last_name, :password, :password_confirmation, :email)
  end

end
