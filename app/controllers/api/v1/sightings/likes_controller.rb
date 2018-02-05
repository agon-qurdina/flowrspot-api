# Likes Controller
class Api::V1::Sightings::LikesController < Api::V1::Sightings::BaseController
  skip_before_action :authenticate_api_user, only: [:index]
  before_action :check_if_exists, only: [:create]

  def index
    render likes_response
  end

  def create
    like = Like.new(user: current_user)
    return render likes_response if @sighting.likes << like
    render json: { error: like.errors.full_messages }, status: 400
  end

  def destroy
    @sighting.my_likes(current_user).destroy_all
    render likes_response
  end

  private

  def likes_response
    return { json: { likes: [] } } if @sighting.likes.blank?
    paginated_likes = @sighting.likes.page(params[:page]).per(params[:per_page])
    {
      json: paginated_likes,
      meta: generate_pagination(paginated_likes),
      each_serializer: LikeSerializer
    }
  end

  def check_if_exists
    render likes_response if @sighting.my_likes(current_user).count > 0
  end
end
