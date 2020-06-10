require 'rails_helper'

RSpec.describe Rank, type: :model do
  it { should belong_to :rankable }
  it { should belong_to(:user) }
end