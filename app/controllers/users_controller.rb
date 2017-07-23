class UsersController < ApplicationController
  def index
    @users = User.all
    json_response(@users)
  end

  def show
    @user = User.find(params[:id])
    json_response(@user)
  end

  def create
    @user = User.create!(user_params)
    json_response(@user, :created)
  end

  def login 
    @user = User.find_by(username: params[:username].to_s.downcase)

    if @user && @user.authenticate(params[:password])
      json_response(@user)
    else
      json_response( {message: 'Invalid credentials' }, :unauthorized)
    end

  end

  private

  def user_params
    params.permit(:first_name, :last_name, :username, :password)
  end
end