class QuestionBroadcastJob < ApplicationJob
  queue_as :default

  def perform(question)
    ActionCable.server.broadcast "questions_channel", {
      question: render(question)
    }
  end

  private

  def render(question)
    QuestionsController.render(
      partial: 'question',
      locals: {
        question: question
      }
    )
  end
end
