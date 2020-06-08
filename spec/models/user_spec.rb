require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:rewards).dependent(:destroy) }
  it { should have_many(:ranks) }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    context 'if user is owner' do
      before { question.stub(:user_id) { user.id } }
      it 'should return true' do
        expect(user).to be_author_of(question)
      end
    end

    context 'if user is not owner' do
      before { question.stub(:user_id) { 5 } }
      it 'should return false' do
        expect(user).to_not be_author_of(question)
      end
    end
  end
end
