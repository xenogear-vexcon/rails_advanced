class AnswerBroadcastJob < ApplicationJob
  queue_as :default

  def perform(answer)
    ActionCable.server.broadcast "question_#{answer.question.id}_answers_channel", {
      answer: render(answer)
    }
  end

  private

  def render(answer)
    AnswersController.renderer.instance_variable_set(:@env, {"HTTP_HOST"=>"localhost:3000", 
      "HTTPS"=>"off", 
      "REQUEST_METHOD"=>"GET", 
      "SCRIPT_NAME"=>"",   
      "warden" => warden
    })

    AnswersController.render(
      rank: answer.ranks.sum(:result),
      partial: 'answers/answer',
      locals: {
        answer: answer
      }
    )
  end
end
