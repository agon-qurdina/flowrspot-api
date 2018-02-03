class Api::V1::FlowersController < Api::V1::BaseController
  skip_before_action :authenticate_api_user
  before_action :flower, only: [:show]

  def index
    @flowers = Flower.alphabetical.page(params[:page]).per(params[:per_page])
    render json: @flowers,
      root: :flowers,
      meta: generate_pagination(@flowers),
      each_serializer: FlowersSerializer
  end

  def search
    @flowers = Flower.search_by_names(params[:query]).alphabetical.page(params[:page]).per(params[:per_page])
    render json: @flowers,
      root: :flowers,
      meta: generate_pagination(@flowers),
      each_serializer: FlowersSerializer
  end

  def show
    render json: flower, serializer: FlowerSerializer
  end

  def create
    @flower = Flower.new(flower_params)
    if @flower.save
      render json: @flower, serializer: FlowerSerializer
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
end
