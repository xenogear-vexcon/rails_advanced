class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  default_scope -> { order(created_at: :desc) }

  validates :body, presence: true

  def mark_as_best
    self.question.answers.update(best_answer: false)
    self.update(best_answer: true)
  end
end
