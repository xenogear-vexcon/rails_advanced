require 'rails_helper'

shared_examples_for "rankable" do
  it { should have_many(:ranks).dependent(:destroy) }

  let!(:users) { create_list(:user, 2) }
  let(:model) { create(described_class.to_s.underscore, user: users.second) }

  it "give current object rating" do
    expect(model.ranks.sum(:result)).to eq 0
  end

  it "vote rating up" do
    expect{model.rank_up(users.first)}.to change{model.ranks.sum(:result)}.to(1)
  end

  it "vote rating down" do
    expect{model.rank_down(users.first)}.to change{model.ranks.sum(:result)}.to(-1)
  end

  it "can not change own object rating" do
    model.rank_up(users.second)
    expect(model.ranks.sum(:result)).to eq 0
  end

  it "impossible to double vote" do
    model.rank_up(users.first)
    model.rank_up(users.first)
    expect(model.ranks.sum(:result)).to eq 1
  end

  it "check if vote is positive" do
    model.rank_up(users.first)
    expect(model.rank_result(users.first)).to eq 'positive'
  end

  it "check if vote is negative" do
    model.rank_down(users.first)
    expect(model.rank_result(users.first)).to eq 'negative'
  end
end