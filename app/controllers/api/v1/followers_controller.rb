class Api::V1::FollowersController < Api::ApplicationController
  before_action :set_follower, only: [:show, :update, :destroy]

  # GET /followers
  def index
    @followers = Follower.all

    render json: @followers
  end

  # GET /followers/1
  def show
    par = params[:user_id]
    followers = User.find(par).followers
    render json: followers
  end

  # POST /followers
  def create
    job = UserFollowersJob.perform_later(@current_user)
    if job
      render json: {message: 'Followers update triggered'}, status: :created
    else
      render json: @follower.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /followers/1
  def update
    if @follower.update(follower_params)
      render json: @follower
    else
      render json: @follower.errors, status: :unprocessable_entity
    end
  end

  # DELETE /followers/1
  def destroy
    @follower.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_follower
    # @follower = Follower.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def follower_params
    params.fetch(:follower, {})
  end
end
