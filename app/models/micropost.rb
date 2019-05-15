class Micropost < ApplicationRecord
  belongs_to :user
  has_many :users, through: :favorites
  has_many :favorites, foreign_key: "micropost_id", dependent: :destroy
  validates :content, presence: true, length: { maximum:255 }
end