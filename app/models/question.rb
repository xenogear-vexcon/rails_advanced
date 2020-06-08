class Question < ApplicationRecord
  include Rankable

  belongs_to :user
  has_many :answers, dependent: :destroy
  
  has_many :links, dependent: :destroy, as: :linkable
  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  has_one :reward, dependent: :destroy
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  has_many_attached :files, dependent: :destroy

  validates :title, :body, presence: true

end
