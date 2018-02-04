class Api::V1::Sightings::LikesController < Api::V1::Sightings::BaseController
  skip_before_action :authenticate_api_user, only: [:index]

  def index
    render likes_paginated_response
  end

  def create
    return render likes_paginated_response if @sighting.user_likes(current_user).count > 0
    like = Like.new(user: current_user)
    return render likes_paginated_response if @sighting.likes << like
    render json: { error: like.errors.full_messages }, status: 400
  end

  def destroy
    @sighting.user_likes(current_user).destroy_all
    render likes_paginated_response
  end

  private

  def likes_paginated_response
    return { json: { likes: [] } } if @sighting.likes.blank?
    paginated_likes = @sighting.likes.page(params[:page]).per(params[:per_page])
    {
      json: paginated_likes,
      meta: generate_pagination(paginated_likes),
      each_serializer: LikeSerializer
    }
  end
end
