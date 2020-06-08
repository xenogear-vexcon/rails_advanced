class Rank < ApplicationRecord
  belongs_to :rankable, polymorphic: true
  belongs_to :user, optional: true
end