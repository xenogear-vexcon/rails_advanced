class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: %i[show destroy]
  before_action :load_answers, only: %i[show]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = Question.new
  end

  # def edit
  # end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new, notice: "Title can't be blank"
    end
  end

  # def update
  #   if @question.update(question_params)
  #     redirect_to @question
  #   else
  #     render :edit
  #   end
  # end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question successfully deleted.'
    else
      redirect_to @question, notice: "Not your question!"
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def load_answers
    @answers = Answer.where(question_id: @question.id)
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
