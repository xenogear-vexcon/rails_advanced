require 'rails_helper'

shared_examples_for "ranked" do
  let(:model) { create described_class.controller_name.singularize.to_sym }
  let(:users) { create_list(:user, 2) }

  describe 'PATCH #up' do
    context 'authenticated user' do
      context 'vote alient model' do
        before { login(users.first) }

        it 'model rating up' do
          patch :up, params: { id: model }, format: :json
          expect(model.rating).to eq 1
        end

        it 'cannot change rating by 2' do
          patch :up, params: { id: model, model: { status: 2 } }, format: :json
          expect(model.rating).to eq 1
        end
      end #vote alient model

      context 'vote own model' do
        it 'cannot affect rating' do
          login(model.user)
          patch :up, params: { id: model }, format: :json
          expect(model.rating).to eq 0
        end
      end #vote own model
    end #authenticated user

    context 'unauthenticated user' do
      it 'cannot vote' do
        patch :up, params: { id: model }, format: :json
        expect(model.rating).to eq 0
      end
    end #unauthenticated user
  end #PATCH #up

  describe 'PATCH #down' do
    context 'authenticated user' do
      context 'vote alient model' do
        before { login(users.first) }

        it 'model rating down' do
          patch :down, params: { id: model }, format: :json
          expect(model.rating).to eq -1
        end

        it 'cannot change rating by 2' do
          patch :down, params: { id: model, model: { status: -2 } }, format: :json
          expect(model.rating).to eq -1
        end
      end #vote alient model

      context 'vote own model' do
        it 'cannot affect rating' do
          login(model.user)
          patch :down, params: { id: model }, format: :json
          expect(model.rating).to eq 0
        end
      end #vote own model
    end #authenticated user

    context 'unauthenticated user' do
      it 'cannot vote' do
        patch :down, params: { id: model }, format: :json
        expect(model.rating).to eq 0
      end
    end #unauthenticated user
  end #PATCH #down

end