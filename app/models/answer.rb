class Answer < ApplicationRecord
  include Rankable
  include Commentable
  
  belongs_to :question
  belongs_to :user

  has_many :links, dependent: :destroy, as: :linkable
  has_many_attached :files, dependent: :destroy

  default_scope -> { order(created_at: :asc) }

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  # after_create_commit { AnswerBroadcastJob.perform_later(self) }


  def mark_as_best
    transaction do
      self.question.answers.update(best_answer: false)
      self.update!(best_answer: true)
      self.question.reward.update!(user: self.user)
    end
  end

  def not_best?
    !best_answer?
  end
end
