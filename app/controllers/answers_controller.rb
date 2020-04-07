  class AnswersController < ApplicationController
  before_action :authenticate_user!

  # def new
  #   @answer = question.answers.new
  # end

  # def edit; end

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @question, notice: "Your answer successfully created"
    else
      render 'questions/show'
    end
  end

  # def update
  #   if answer.update(answer_params)
  #     redirect_to @answer
  #   else
  #     render :edit
  #   end
  # end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to @answer.question, notice: "Your answer successfully deleted"
    else
      render 'questions/show', notice: "Not your answer!"
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def question
    @question ||= Question.find(params[:question_id])
  end
end
