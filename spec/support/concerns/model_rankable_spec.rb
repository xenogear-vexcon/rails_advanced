require 'rails_helper'

shared_examples_for "rankable" do
  it { should have_many(:ranks).dependent(:destroy) }

  let!(:users) { create_list(:user, 2) }
  let(:model) { create(described_class.to_s.underscore, user: users.second) }

  it "give current object rating" do
    expect(model.rating).to eq 0
  end

  it "vote rating up" do
    expect{model.rating_up(users.first)}.to change{model.rating}.to(1)
  end

  it "vote rating down" do
    expect{model.rating_down(users.first)}.to change{model.rating}.to(-1)
  end

  it "can not change own object rating" do
    model.rating_up(users.second)
    expect(model.rating).to eq 0
  end

  it "impossible to double vote" do
    model.rating_up(users.first)
    model.rating_up(users.first)
    expect(model.rating).to eq 1
  end

  it "check if vote is positive" do
    model.rating_up(users.first)
    expect(model.positive_vote?(users.first)).to eq true
  end

  it "check if vote is negative" do
    model.rating_down(users.first)
    expect(model.negative_vote?(users.first)).to eq true
  end
end