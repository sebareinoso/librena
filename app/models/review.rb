class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :user_id, uniqueness: { scope: :book_id, message: 'has already reviewed this book' }
  validates :comment, length: { maximum: 1000 }
end
