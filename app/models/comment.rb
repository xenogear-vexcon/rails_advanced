class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  default_scope -> { order(created_at: :asc) }

  validates :body, presence: true

  def comment_class_title
    "#{commentable_type.downcase}_#{commentable_id}_comments"
  end

  def comment_error_title
    "#{commentable_type.downcase}_#{commentable_id}_comment_errors"
  end

  def question_id
    commentable_type=='Question' ? commentable_id : commentable.question.id
  end
end
