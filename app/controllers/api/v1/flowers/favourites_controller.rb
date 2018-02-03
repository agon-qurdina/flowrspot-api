class Api::V1::Flowers::FavouritesController < Api::V1::Flowers::BaseController
  skip_before_action :set_flower, only: [:index]

  def index
    render json: current_user.favourites.page(params[:page]).per(params[:per_page]), meta: generate_pagination(current_user.favourites), each_serializer: FavouriteSerializer
  end

  def create
    if current_user.favourites.where(flower: @flower).count > 0
      render json: current_user.favourites.page(params[:page]).per(params[:per_page]), meta: generate_pagination(current_user.favourites), each_serializer: FavouriteSerializer
    else
      favourite = Favourite.new(flower: @flower)
      if current_user.favourites << favourite
        render json: current_user.favourites.page(params[:page]).per(params[:per_page]), meta: generate_pagination(current_user.favourites), each_serializer: FavouriteSerializer
      else
        render json: { error: favourite.errors.full_messages }, status: 400
      end
    end
  end

  def destroy
    current_user.favourites.where(flower: @flower).destroy_all
    render json: current_user.favourites.page(params[:page]).per(params[:per_page]), meta: generate_pagination(current_user.favourites), each_serializer: FavouriteSerializer
  end
end
