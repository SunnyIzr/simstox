class UsersController < ApplicationController
  def index
    @users = User.all
    json_response(@users)
  end

  def show
    return if authenticate!(current_user)

    json_response(current_user)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auth_token = JsonWebToken.encode({user_id: @user.id})
      json_response({ token: auth_token, user: JSON.parse(UserSerializer.new(@user).to_json) }, :created)
    else
      json_response( @user.errors.full_messages, :unprocessable_entity)
    end
  end

  def login 
    @user = User.find_by(username: params[:username].to_s.downcase)

    if @user && @user.authenticate(params[:password])
      auth_token = JsonWebToken.encode({user_id: @user.id})
      json_response({ token: auth_token, user: JSON.parse(UserSerializer.new(@user).to_json) })
    else
      json_response( {message: 'Invalid credentials' }, :unauthorized)
    end

  end

  private

  def user_params
    params.permit(:first_name, :last_name, :username, :password)
  end
end