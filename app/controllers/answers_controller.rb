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
    @answer.mark_as_best if current_user.author_of?(@question)
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
