class CommentsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_comment, only: %i[edit update destroy]

  def create
    @commentable = set_commentable
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    gon.commentable_id = @comment.commentable_id
    if @comment.save
      publish_comment
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
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
    ActionCable.server.broadcast("question_#{@comment.question_id}_comments_channel", comment: render_comment,
      commentable_class: @comment.comment_class_title
    )
  end

  def render_comment
    CommentsController.renderer.instance_variable_set(:@env, {"HTTP_HOST"=>"localhost:3000",
      "HTTPS"=>"off",
      "REQUEST_METHOD"=>"GET",
      "SCRIPT_NAME"=>"",
      "warden" => warden
    })

    CommentsController.render(
      partial: 'comments/comment',
      locals: {
        comment: @comment
      }
    )
  end
end
