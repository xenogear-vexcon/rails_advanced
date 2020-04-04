class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :user_is_author, only: %i[destroy]

  # def edit; end

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @question, notice: 'Your answer successfully created.'
    else
      redirect_to @question, notice: "Answer can't be blank"
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
    @answer.destroy
    redirect_to question_path(@answer.question), notice: 'Your answer successfully deleted.'
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def user_is_author
    @answer = Answer.find(params[:id])
    redirect_to(question_path(@answer.question)) unless @answer.user == current_user
  end
end
