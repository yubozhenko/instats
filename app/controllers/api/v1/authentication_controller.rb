class Api::V1::AuthenticationController < Api::ApplicationController

  skip_before_action :authenticate_request

  def authenticate
    command = AuthenticateUser.call(params[:username], params[:password])
    if command.success?
      Instagram.login(params[:username], params[:password])
      render json: {auth_token: command.result}
    else
      render json: {error: command.errors}, status: :unauthorized
    end
  end
end