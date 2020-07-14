require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_db_index :question_id }
  it { should have_db_index :user_id }
  it { should validate_presence_of :body }
  it_behaves_like "rankable"
  it_behaves_like "commentable"
  Answer.order('created_at desc')

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#mark_as_best' do
    let!(:users) { create_list(:user, 2) }
    let!(:question) { create(:question, user: users.first) }
    let!(:reward) { create(:reward, question: question, user: users.first) }
    let!(:answer1) { create(:answer, question: question, user: users.second) }
    let!(:answer2) { create(:answer, question: question, user: users.first, best_answer: true) }

    it 'answer become best' do
      expect{answer1.mark_as_best}.to change{answer1.best_answer}.to(true)
    end

    it 'other answer become usual' do
      expect{answer1.mark_as_best}.to change{answer2.reload.best_answer}.to(false)
    end

    it 'user receive reward' do
      expect{answer1.mark_as_best}.to change{reward.reload.user}.to(users.second)
    end

    it 'previous user lost reward' do
      expect{answer1.mark_as_best}.to change{users.first.reload.rewards.count}.to(0)
    end
  end
end
