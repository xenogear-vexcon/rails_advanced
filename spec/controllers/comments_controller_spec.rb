require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:users) { create_list(:user, 2) }
  let!(:question) { create(:question, user: users.first) }
  let!(:answer) { create(:answer, question: question, user: users.first) }

  describe 'POST #create' do
    context 'authenticated user' do
      before { login(users.first) }
      
      context 'with valid attributes' do
        it 'saves a new comment in the database' do
          expect { post :create, params: { comment: attributes_for(:comment), commentable: question, user_id: users.first) }, format: :json }.to change(Comment, :count).by(1)
        end

        it 'redirects to question show view'
      end

      context 'with not valid attributes'
    end
  end

  describe 'DELETE #destroy' do
    let!(:comment) { create(:comment, commentable: question, user: users.first) }

    context 'if user not authorized or not an owner' do
      it "can't delete comment from db" do
        expect { delete :destroy, params: { id: comment } }.to_not change(Comment, :count)
      end

      it 'redirect to question' do
        delete :destroy, params: { id: comment }
        expect(response).to redirect_to question
      end
    end

    context 'if user is owner' do
      before { login(users.first) }
      
      it 'delete comment from db' do
        expect { delete :destroy, params: { id: comment }, format: :json }.to change(Comment, :count).by(-1)
      end

      it 'redirect to question' do
        delete :destroy, params: { id: comment }, format: :json
        expect(response).to render_template :destroy
      end
    end
  end
end
