# frozen_string_literal: true

class Book < ApplicationRecord
  validates :title, presence: true, length: { minimum: 2 }
  validates :summary, presence: true
  validates :author, presence: true

  has_many :reviews, dependent: :destroy
  has_many :users, through: :reviews
end
