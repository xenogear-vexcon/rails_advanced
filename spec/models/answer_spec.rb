require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_db_index :question_id }
  it { should have_db_index :user_id }
  it { should validate_presence_of :body }
  Answer.order('created_at desc')

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
