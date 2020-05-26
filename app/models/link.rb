class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  default_scope -> { order(created_at: :asc) }

  validates :name, :url, presence: true
  validates :url, http_url: true

  def gist?
    url.include?("gist.github.com")
  end
end
