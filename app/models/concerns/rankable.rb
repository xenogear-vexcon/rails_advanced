module Rankable
  extend ActiveSupport::Concern

  included do
    has_many :ranks, :as => :rankable, dependent: :destroy
  end

  def rating
    Rank.where(rankable: self).sum(:result)
  end

  def rating_up(user)
    vote = Rank.find_by(rankable: self, user_id: user.id)

    if self.user_id != user.id
      if !vote.present?
        Rank.create!(rankable: self, user_id: user.id, result: 1)
      elsif vote.result == -1
        vote.update!(result: 0)
      elsif vote.result == 0
        vote.update!(result: 1)
      end
    end
  end

  def rating_down(user)
    vote = Rank.find_by(rankable: self, user_id: user.id)

    if self.user_id != user.id
      if !vote.present?
        Rank.create!(rankable: self, user_id: user.id, result: -1)
      elsif vote.result == 1
        vote.update!(result: 0)
      elsif vote.result == 0
        vote.update!(result: -1)
      end
    end
  end

  def positive_vote?(user)
    vote = Rank.find_by(rankable: self, user_id: user.id)
    if vote.present?
      vote.result == 1
    end
  end

  def negative_vote?(user)
    vote = Rank.find_by(rankable: self, user_id: user.id)
    if vote.present?
      vote.result == -1
    end
  end
end