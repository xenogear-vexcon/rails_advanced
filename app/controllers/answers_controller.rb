class AnswersController < ApplicationController
  include Ranked

  before_action :authenticate_user!
  before_action :set_answer, only: %i[edit update destroy mark_as_best]
  before_action :set_question, only: %i[create]
  after_action :publish_answer, only: %i[create]

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
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast('answers_channel',
      ApplicationController.render_with_signed_in_user(current_user, rank: @answer.ranks.sum(:result), partial: 'answers/answer', locals: {answer: @answer})
    )
  end

end
