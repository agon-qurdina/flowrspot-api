class Api::V1::BaseController < Api::V1::ApplicationController
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: exception.message }, status: 404
  end
  rescue_from ActionController::ParameterMissing do |exception|
    render json: { error: exception.message }, status: 400
  end
  before_action :authenticate_api_user

  attr_reader :current_user

  protected

  def authenticate_api_user
    auth_api = AuthApiService.new(request.headers)
    @current_user = auth_api.call
    return if @current_user
    render json: { error: 'Not authorized' }, status: 401
  end
end
