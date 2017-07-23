class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler
  
  def authenticate_request!
    json_response( {error: 'Permission denied'}, :unauthorized) unless logged_in?
  end

  def current_user
    if auth_present?
      User.find_by(id: auth['user_id'])
    end
  end

  def logged_in?
    !!current_user
  end

  private

  def auth
    JsonWebToken.decode(token)
  end

  def token
    request.env["HTTP_AUTHORIZATION"]
  end

  def auth_present?
    !!auth
  end
end
