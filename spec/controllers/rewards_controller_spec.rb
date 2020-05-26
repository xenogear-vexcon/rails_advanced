require 'rails_helper'

RSpec.describe RewardsController, type: :controller do

  describe "GET #index" do
    let(:users) { create_list(:user, 2) }
    let(:question1) { create(:question, user: users.first) }
    let(:question2) { create(:question, user: users.first) }
    let(:reward1) { create(:user_reward, question: question1, user: users.second) }
    let(:reward2) { create(:user_reward, question: question2, user: users.second) }
    
    context 'authenticated user' do
      before { login(users.second) }
      context 'will see own rewards' do
        before { get :index, params: {user_id: users.second.id} }

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end

        it "returns user rewards" do
          expect(assigns(:rewards)).to match_array([reward1, reward2])
        end

        it 'renders index view' do
          expect(response).to render_template :index
        end
      end
    end
  end
end
