class CommentsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_comment, only: %i[edit update destroy]
  after_action :publish_comment, only: %i[create]

  def create
    @commentable = set_commentable
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if !@comment.save
      render json: {errors: @comment.errors.full_messages, status: :unprocessable_entity}
    end
  end

  def edit; end

  def update
    @comment.update(comment_params) if current_user.author_of?(@comment)
  end

  def destroy
    @comment.destroy if current_user.author_of?(@comment)
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value) 
      end
    end
    nil
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast('comments_channel',
      comment: ApplicationController.render_with_signed_in_user(current_user, partial: 'comments/comment', locals: {comment: @comment}), 
      commentable_class: "#{@comment.commentable_type.downcase}_#{@comment.commentable_id}_comments"
    )
  end
end
