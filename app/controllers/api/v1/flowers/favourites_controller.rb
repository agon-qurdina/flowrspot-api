class Api::V1::Flowers::FavouritesController < Api::V1::Flowers::BaseController
  skip_before_action :set_flower, only: [:index]

  def index
    @favourites = current_user.favourites
    render favourites_paginated_response
  end

  def create
    if current_user.flower_favourites(@flower).count.zero?
      favourite = Favourite.new(flower: @flower)
      unless current_user.favourites << favourite
        return render json: { error: favourite.errors.full_messages }, status: 400
      end
    end
    @favourites = current_user.favourites
    render favourites_paginated_response
  end

  def destroy
    current_user.flower_favourites(@flower).destroy_all
    @favourites = current_user.favourites
    render favourites_paginated_response
  end

  private

  def favourites_paginated_response
    return { json: { favourites: [] } } if @favourites.blank?
    paginated_favourites = @favourites.page(params[:page]).per(params[:per_page])
    {
      json: paginated_favourites,
      meta: generate_pagination(paginated_favourites),
      each_serializer: FavouriteSerializer
    }
  end
end
