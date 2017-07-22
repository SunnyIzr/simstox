class UsersController < ApplicationController
  def index
  end

  def show
    @user = User.find(params[:id])
    json_response(@user)
  end
end