# frozen_string_literal: true

class Book < ApplicationRecord
  validates :title, presence: true, length: { minimum: 2 }
  validates :summary, presence: true
  validates :author, presence: true

  has_many :reviews, dependent: :destroy
  has_many :users, through: :reviews

  def short_summary
    return summary if summary.length <= 100

    summary.first(100) + '...'
  end

  def score
    return 0 if reviews.count < 3

    reviews.average(:rating).round(1)
  end
end
