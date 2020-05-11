class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
    @answer = question.answers.new
    @best_answer = question.answers.where(best_answer: true)
    @other_answers = question.answers.where.not(best_answer: true)
  end

  def new
    @question = current_user.questions.new
  end

  def edit
    if current_user.author_of?(question)
      @question = Question.find(params[:id])
    end
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    question.update(question_params) if current_user.author_of?(question)
  end

  def destroy
    if current_user.author_of?(question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question successfully deleted.'
    else
      redirect_to @question, notice: "Not your question!"
    end
  end

  def delete_file_attachment
    @file = ActiveStorage::Attachment.find(params[:id])
    @file.purge
    @question = Question.find(@file.record_id)
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end

end
