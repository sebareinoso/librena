# frozen_string_literal: true

class Book < ApplicationRecord
  validates :title, presence: true, length: { minimum: 2 }
  validates :summary, presence: true
end
