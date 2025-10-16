# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:book) }
  end

  describe 'validations' do
    context 'when rating is missing' do
      it 'is invalid' do
        review = described_class.new rating: nil
        expect(review).not_to be_valid
      end
    end

    context 'when rating is zero' do
      it 'is invalid' do
        review = described_class.new rating: 0
        expect(review).not_to be_valid
      end
    end

    context 'when rating is negative' do
      it 'is invalid' do
        review = described_class.new rating: -1
        expect(review).not_to be_valid
      end
    end

    context 'when rating is over 5' do
      it 'is invalid' do
        review = described_class.new rating: 6
        expect(review).not_to be_valid
      end
    end

    context 'when rating is a float' do
      it 'is invalid' do
        review = described_class.new rating: 1.5
        expect(review).not_to be_valid
      end
    end

    context 'when rating is correct' do
      it 'is valid' do
        review = described_class.new rating: 3
        expect(review).to be_valid
      end
    end

    context 'when user reviews a book twice' do
      it 'is invalid' do
        user = User.create! username: 'Mr rater', email: 'test@test.com', password: '123456'
        book = Book.create! title: 'Book A', summary: 'A book about books'
        described_class.create! user:, book:, rating: 4, comment: ''
        dupe_review = described_class.new user:, book:, rating: 3, comment: 'Average'
        expect(dupe_review).not_to be_valid
      end
    end

    context 'when user reviews another book' do
      it 'is valid' do
        user = User.create! username: 'Mr rater', email: 'test@test.com', password: '123456'
        book_one = Book.create! title: 'Book A', summary: 'A book about books'
        book_two = Book.create! title: 'Necronomicon', summary: 'Find out yourself'
        described_class.create! user:, book: book_one, rating: 4, comment: ''
        second_review = described_class.new user:, book: book_two, rating: 5, comment: '5/5'
        expect(second_review).to be_valid
      end
    end
  end

  describe 'database indexes' do
    it { is_expected.to have_db_index(%i[user_id book_id]).unique(true) }
  end
end
