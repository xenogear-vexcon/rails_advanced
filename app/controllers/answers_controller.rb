  class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: %i[edit update destroy mark_as_best]
  before_action :set_question, only: %i[create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def edit; end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    @question = @answer.question
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def mark_as_best
    @question = @answer.question
    if current_user.author_of?(@question)
      @question.answers.update(best_answer: false)
      @answer.update(best_answer: true)
    else
      render status: :forbidden
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

end
