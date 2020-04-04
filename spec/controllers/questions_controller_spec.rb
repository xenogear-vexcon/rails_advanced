require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:users) { create_list(:user, 2) }
  let(:question) { create(:question, user: users.first) }
  
  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }


    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end


    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(users.first) }
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'authenticated user' do
      before { login(users.first) }

      context 'with valid attributes' do
        it 'saves a new question in the database' do
          expect { post :create, params: { question: attributes_for(:question), user: users.first } }.to change(users.first.questions, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, params: { question: attributes_for(:question), user: users.first }
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post :create, params: { question: attributes_for(:question, :invalid), user: users.first } }.to_not change(users.first.questions, :count)
        end


        it 're-renders new view' do
          post :create, params: { question: attributes_for(:question, :invalid), user: users.first }
          expect(response).to render_template :new
        end
      end
    end

    context 'not authenticated user' do
      it 'does not save question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to_not change(Question, :count)
      end

      it 're-renders sign_in view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user: users.first) }

    context 'if user not authorized' do
      it "can't delete question from db" do
        expect { delete :destroy, params: { id: question } }.to_not change(users.first.questions, :count)
      end

      it 'redirect to question' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'if user is owner' do
      before { login(users.first) }
      
      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(users.first.questions, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'if user tries to delete alien answer' do
      before { login(users.second) }

      it "can't delete question from db" do
        expect { delete :destroy, params: { id: question } }.to_not change(users.first.questions, :count)
      end

      it 'redirect to question' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to assigns(:question)
      end
    end
  end

  # describe 'GET #edit' do
  #   before { login(user) }

  #   before { get :edit, params: { id: question } }

  #   it 'assigns the requested question to @question' do
  #     expect(assigns(:question)).to eq question
  #   end


  #   it 'renders edit view' do
  #     expect(response).to render_template :edit
  #   end
  # end

  # describe 'PATCH #update' do
  #   before { login(user) }

  #   context 'with valid attributes' do
  #     it 'assigns the requested question to @question' do
  #       patch :update, params: { id: question, question: attributes_for(:question) }
  #       expect(assigns(:question)).to eq question
  #     end

  #     it 'changes question attributes' do
  #       patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }
  #       question.reload

  #       expect(question.title).to eq 'new title'
  #       expect(question.body).to eq 'new body'
  #     end

  #     it 'redirects to updated question' do
  #       patch :update, params: { id: question, question: attributes_for(:question) }
  #       expect(response).to redirect_to question
  #     end
  #   end

  #   context 'with invalid attributes' do
  #     before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }

  #     it 'does not change question' do
  #       question.reload

  #       expect(question.title).to eq 'MyString'
  #       expect(question.body).to eq 'MyText'
  #     end

  #     it 're-renders edit view' do
  #       expect(response).to render_template :edit
  #     end
  #   end
  # end
end
