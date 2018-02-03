class Api::V1::Sightings::LikesController < Api::V1::Sightings::BaseController
  skip_before_action :authenticate_api_user, only: [:index]

  def index
    render json: @sighting.likes, each_serializer: LikeSerializer
  end

  def create
    if @sighting.likes.where(user: current_user).count > 0
      render json: @sighting.likes, each_serializer: LikeSerializer
    else
      like = Like.new(user: current_user)
      if @sighting.likes << like
        render json: @sighting.likes, each_serializer: LikeSerializer
      else
        render json: { error: like.errors.full_messages }, status: 400
      end
    end
  end

  def destroy
    @sighting.likes.where(user: current_user).destroy_all
    render json: @sighting.likes, each_serializer: LikeSerializer
  end
end
