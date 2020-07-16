class Question < ApplicationRecord
  include Rankable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy
  
  has_many :links, dependent: :destroy, as: :linkable
  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  has_one :reward, dependent: :destroy
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  has_many_attached :files, dependent: :destroy

  default_scope -> { order(created_at: :asc) }

  validates :title, :body, presence: true

  after_create_commit :broadcast, on: :create
  # after_destroy :broadcast

  def broadcast
    QuestionBroadcastJob.perform_later(self)
  end

end
