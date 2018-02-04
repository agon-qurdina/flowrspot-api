class Api::V1::SightingsController < Api::V1::BaseController
  skip_before_action :authenticate_api_user, only: [:index, :show, :search_by_location]

  def index
    @sightings = Sighting.all
    render sightings_paginated_response
  end

  def show
    @sighting = Sighting.find params[:id]
    render sighting_response
  end

  def create
    @sighting = Sighting.new(sighting_params)
    @sighting.user = current_user
    if @sighting.save
      render sighting_response
    else
      render json: { error: @sighting.errors.full_messages }, status: 400
    end
  end

  def update
    @sighting = Sighting.find params[:id]
    if @sighting.update(sighting_params)
      render sighting_response
    else
      render json: { error: @sighting.errors.full_messages },
             status: 400
    end
  end

  def destroy
    @sighting = Sighting.find params[:id]
    return render json: { error: @sighting.errors.full_messages } unless @sighting.destroy
    render json: { success: true }
  end

  def search_by_location
    distance = params[:distance]
    center = params[:center]
    @sightings = Sighting.within(distance, origin: center)
    render sightings_paginated_response
  end

  protected

  def sighting_params
    params.permit(:flower_id, :name, :description, :latitude, :longitude,
                  :picture, picture_base: [:filename, :data, :content_type])
  end

  def sightings_paginated_response
    return { json: { sightings: [] } } if @sightings.blank?
    paginated_sightings = @sightings.page(params[:page]).per(params[:per_page])
    {
      json: paginated_sightings,
      meta: generate_pagination(paginated_sightings),
      each_serializer: SightingsSerializer
    }
  end

  def sighting_response
    {
      json: @sighting, serializer: SightingSerializer
    }
  end
end
