class Api::V1::Sightings::CommentsController < Api::V1::Sightings::BaseController
  skip_before_action :authenticate_api_user, only: [:index]
  before_action :set_comment, only: [:destroy]

  def index
    render comments_paginated_response
  end

  def create
    comment = Comment.new(comment_params)
    comment.user = current_user
    if @sighting.comments << comment
      render comments_paginated_response
    else
      render json: { error: comment.errors.full_messages }, status: 400
    end
  end

  def destroy
    if @comment.user == current_user
      @comment.destroy
      return render comments_paginated_response
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

  def comments_paginated_response
    return { json: { comments: [] } } if @sighting.comments.blank?
    paginated_comments = @sighting.comments.page(params[:page]).per(params[:per_page])
    {
      json: paginated_comments,
      meta: generate_pagination(paginated_comments),
      each_serializer: CommentSerializer
    }
  end
end
