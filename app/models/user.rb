class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :rewards, dependent: :destroy
  
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :trackable

  def author_of?(element)
    self.id == element&.user_id
  end
end
