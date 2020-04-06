require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:users) { create_list(:user, 2) }
  let!(:question) { create(:question, user: users.first) }

  describe 'POST #create' do
    context 'authenticated user' do
      before { login(users.first) }
      
      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(question.answers, :count).by(1)
        end

        it 'redirects to question show view' do
          post :create, params: { answer: attributes_for(:answer), question_id: question }
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with not valid attributes' do
        it 'does not save answer in the database' do
          expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not change(question.answers, :count)
        end

        it 're-renders question view' do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
          expect(response).to render_template('questions/show')
        end
      end
    end

    context 'not authenticated user' do
      it 'does not save answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to_not change(question.answers, :count)
      end

      it 're-renders sign_in view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: users.first) }

    context 'if user not authorized' do
      it "can't delete answer from db" do
        expect { delete :destroy, params: { id: answer } }.to_not change(question.answers, :count)
      end

      it 'redirect to question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'if user is owner' do
      before { login(users.first) }
      
      it 'delete answer from db' do
        expect { delete :destroy, params: { id: answer } }.to change(question.answers, :count).by(-1)
      end

      it 'redirect to question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'if user tries to delete alien answer' do
      before { login(users.second) }
      it "can't delete answer from db" do
        expect { delete :destroy, params: { id: answer } }.to_not change(question.answers, :count)
      end

      it 'redirect to question' do
        delete :destroy, params: { id: answer }
        expect(response).to render_template ('questions/show')
      end
    end
  end

  # describe 'PATCH #update' do
  #   before { login(users.first) }

  #   context 'with valid attributes' do
  #     it 'assigns the requested answer to @answer' do
  #       patch :update, params: { id: answer, answer: attributes_for(:answer) }
  #       expect(assigns(:answer)).to eq answer
  #     end

  #     it 'change answer attributes' do
  #       patch :update, params: { id: answer, answer: { body: "new body" } }
  #       answer.reload

  #       expect(answer.body).to eq "new body"
  #     end

  #     it 'redirects to updated answer' do
  #       patch :update, params: { id: answer, answer: attributes_for(:answer) }
  #       expect(response).to redirect_to answer
  #     end
  #   end

  #   context 'with not valid attributes' do
  #     it 'does not change answer' do
  #       patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }
  #       answer.reload

  #       expect(answer.body).to eq "MyText"
  #     end

  #     it 're-renders edit view' do
  #       patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }
  #       expect(response).to render_template :edit
  #     end
  #   end
  # end
end
