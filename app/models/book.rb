# frozen_string_literal: true

class Book < ApplicationRecord
  validates :title, presence: true, length: { minimum: 2 }
  validates :summary, presence: true
  validate :image_validation

  has_one_attached :image

  private

  def image_validation
    return unless image.attached?

    unless image.content_type.in? %w[image/png image/jpg image/jpeg image/webp]
      errors.add :image, 'must be a PNG, JPG, or WEBP'
    end

    return unless image.byte_size > 1.megabyte

    errors.add :image, 'is too large (max is 1 MB)'
  end
end
