class Api::V1::FlowersController < Api::V1::BaseController
  skip_before_action :authenticate_api_user
  before_action :flower, only: [:show]

  def index
    @flowers = Flower.all
    render flowers_paginated_response
  end

  def search
    @flowers = Flower.search_by_names(params[:query])
    render flowers_paginated_response
  end

  def show
    render flower_response
  end

  def create
    @flower = Flower.new(flower_params)
    if @flower.save
      render flower_response
    else
      render json: { error: @flower.errors.full_messages }, status: 400
    end
  end

  private
  def flower
    @flower = Flower.find(params[:id])
  end

  def flower_params
    params.permit(:name, :latin_name, :features, :description, :profile_picture)
  end

  def flowers_paginated_response
    return { json: { flowers: [] } } if @flowers.blank?
    paginated_flowers = @flowers.alphabetical.page(params[:page]).per(params[:per_page])
    {
      json: paginated_flowers,
      meta: generate_pagination(paginated_flowers),
      each_serializer: FlowersSerializer
    }
  end

  def flower_response
    {
      json: @flower,
      serializer: FlowerSerializer
    }
  end
end
