class AuthenticationController < ApplicationController
  extend ActiveSupport::Concern

  included do
    skip_before_action :authenticate_request
  end

  def authenticate
    command = AuthenticateUser.call(params[:email], params[:password])

    if command.success?
      render json: {auth_token: command.result}
    else
      render json: {error: command.errors}, status: :unauthorized
    end
  end
end