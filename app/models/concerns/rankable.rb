module Rankable
  extend ActiveSupport::Concern

  POSITIVE = 1
  NEGATIVE = -1

  included do
    has_many :ranks, :as => :rankable, dependent: :destroy
  end

  def rank_up(user)
    ranking(user, POSITIVE)
  end

  def rank_down(user)
    ranking(user, NEGATIVE)
  end

  def rank_result(user)
    if ranks.find_by(user_id: user.id).present?
      ranks.find_by(user_id: user.id).result > 0 ? :positive : :negative
    end
  end

  private

  def ranking(user, rule)
    rank = ranks.find_by(user_id: user.id)

    if !user.author_of?(self)
      if !rank.present?
        ranks.create!(user_id: user.id, result: rule)
      elsif rank.result != rule
        rank.destroy!
      end
    end
  end

end
