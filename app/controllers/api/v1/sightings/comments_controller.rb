class Api::V1::Sightings::CommentsController < Api::V1::Sightings::BaseController
  skip_before_action :authenticate_api_user, only: [:index]
  before_action :set_comment, only: [:destroy]

  def index
    render json: @sighting.comments, each_serializer: CommentSerializer
  end

  def create
    comment = Comment.new(comment_params)
    comment.user = current_user
    if @sighting.comments << comment
      render json: @sighting.comments, each_serializer: CommentSerializer
    else
      render json: { error: comment.errors.full_messages }, status: 400
    end
  end

  def destroy
    if @comment.user == current_user
      @comment.destroy
      return render json: @sighting.comments, each_serializer: CommentSerializer
    end
    render json: '', status: :unauthorized
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.permit(:comment)
  end
end
