require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:users) { create_list(:user, 2) }
  let(:question) { create(:question, user: users.first) }
  let!(:reward) { create(:reward, question: question) }

  describe 'POST #create' do
    context 'authenticated user' do
      before { login(users.first) }
      
      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(question.answers, :count).by(1)
        end

        it 'redirects to question show view' do
          post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
          expect(response).to render_template :create
        end
      end

      context 'with not valid attributes' do
        it 'does not save answer in the database' do
          expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(question.answers, :count)
        end

        it 're-renders question view' do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }
          expect(response).to render_template :create
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
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(question.answers, :count).by(-1)
      end

      it 'redirect to question' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'if user tries to delete alien answer' do
      before { login(users.second) }
      it "can't delete answer from db" do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(question.answers, :count)
      end

      it 'redirect to question' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: users.first) }

    context 'authenticated user own answer' do
      before { login(users.first) }

      context 'with valid attributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with not valid attributes' do
        it 'does not change answer' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js

          expect(answer.body).to eq answer.body
        end

        it 're-renders edit view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end #end context own question

    context 'authenticated user trying to change alien answer' do
      before { login(users.second) }

      it 'does not change answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js

        expect(answer.body).to eq answer.body
      end

      it 're-renders edit view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'if user not authorized' do
      it "can't edit answer" do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js

        expect(answer.body).to eq answer.body
      end

      it 'redirect to question' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end #end patch update

  describe 'GET #edit' do
    let!(:answer) { create(:answer, question: question, user: users.first) }
    before { login(users.first) }

    it 'assigns the requested answer to @answer' do
      expect(answer.body).to eq answer.body
    end
  end #end get edit

  describe 'PATCH #mark_as_best' do
    let!(:answer) { create(:answer, question: question, user: users.first) }

    context 'authenticated user, question owner' do
      before { login(users.first) }

      it 'changes answer attributes' do
        patch :mark_as_best, params: { id: answer, answer: { best_answer: true } }, format: :js
        answer.reload

        expect(answer.best_answer).to eq true
      end

      it 'gives reward to user' do
        patch :mark_as_best, params: { id: answer, answer: { best_answer: true } }, format: :js
        expect(users.first.rewards.count).to eq 1
      end

      it 'render answer' do
        patch :mark_as_best, params: { id: answer, answer: { best_answer: true } }, format: :js
        expect(response).to render_template :mark_as_best
      end
    end

    context 'authenticated user, alien question' do
      before { login(users.second) }

      it "doesn't change answer attributes" do
        patch :mark_as_best, params: { id: answer, answer: { best_answer: true } }, format: :js
        answer.reload

        expect(answer.best_answer).to eq false
      end

      it "doesn't render best_answer template" do
        expect(response).to_not render_template :mark_as_best
      end
    end
  end

end


