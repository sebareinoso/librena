# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Reviews', type: :request do
  let(:user) { User.create! username: 'AntonE', email: 'test@test.com', password: '123456' }
  let(:book) { Book.create! title: 'Book A', summary: 'Book A summary' }

  describe 'POST /books/:book_id/reviews' do
    context 'when params are valid' do
      let(:valid_params) do
        { review: { user_id: user.id, rating: 5 } }
      end

      it 'creates a review' do
        expect do
          post book_reviews_path(book), params: valid_params
        end.to change(Review, :count).by(1)
      end

      it 'redirects to the book page' do
        post book_reviews_path(book), params: valid_params
        expect(response).to redirect_to(book_path(book))
      end
    end

    context 'when user already reviewed the book' do
      before { Review.create! user:, book:, rating: 3 }

      it 'does not create a new review' do
        expect do
          post book_reviews_path(book), params: { review: { user_id: user.id, rating: 4, comment: 'Second time' } }
        end.not_to change(Review, :count)
      end
    end
  end
end
