class Micropost < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: Settings.max_content_length }
  scope :sort_scope, -> { order(created_at: :desc) }
end
