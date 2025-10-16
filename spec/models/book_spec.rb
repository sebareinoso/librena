# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'validations' do
    context 'when title is missing' do
      it 'is invalid' do
        book = described_class.new summary: 'Book A summary'
        expect(book).not_to be_valid
      end
    end

    context 'when summary is missing' do
      it 'is invalid' do
        book = described_class.new title: 'Book A'
        expect(book).not_to be_valid
      end
    end

    context 'when params are correct' do
      it 'is valid' do
        book = described_class.new title: 'Book A', summary: 'Book A summary'
        expect(book).to be_valid
      end
    end

    context 'when title is too short (minimum is 2 characters)' do
      it 'is invalid' do
        book = described_class.new title: 'A', summary: 'A summary'
        expect(book).not_to be_valid
      end
    end

    context 'when attached file is not an image (must be PNG, JPG or WEBP)' do
      it 'is invalid' do
        book = described_class.new(title: 'Book A', summary: 'Book A summary')
        book.image.attach(
          io: File.open(Rails.root.join('spec/fixtures/files/book.txt')),
          filename: 'book.txt',
          content_type: 'text/plain'
        )
        expect(book).not_to be_valid
      end
    end

    context 'when attached file is too large (max is 1 MB)' do
      it 'is invalid' do
        book = described_class.new(title: 'Book A', summary: 'Book A summary')
        book.image.attach(
          io: StringIO.new('a' * 1025.kilobytes),
          filename: 'book.jpg',
          content_type: 'image/jpeg'
        )
        expect(book).not_to be_valid
      end
    end
  end
end
