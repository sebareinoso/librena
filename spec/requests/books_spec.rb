# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Books', type: :request do
  describe 'GET /books' do
    it 'returns a success response' do
      get books_path
      expect(response).to be_successful
    end

    context 'when there are books' do
      it 'returns a populated @books' do
        book_one = Book.create! title: 'Book A', summary: 'Book A summary', author: 'Person'
        book_two = Book.create! title: 'Book B', summary: 'Book B is great', author: 'Person'
        get books_path
        expect(response.body).to include book_one.title
        expect(response.body).to include book_two.title
        expect(response).to have_http_status :ok
      end
    end
  end

  describe 'GET /book/:id' do
    it 'returns a success response' do
      book = Book.create! title: 'Book A', summary: 'Book A summary', author: 'Person'
      get book_path(book), params: { id: book.id }
      expect(response).to be_successful
    end
  end

  describe 'POST /books' do
    context 'with empty title' do
      it 'does not create a new Book' do
        expect do
          post books_path, params: { book: { title: nil, author: 'Person' } }
        end.not_to change(Book, :count)
      end
    end

    context 'with short title' do
      it 'does not create a new Book' do
        expect do
          post books_path, params: { book: { title: 'A', author: 'Person' } }
        end.not_to change(Book, :count)
      end
    end

    context 'with empty summary' do
      it 'does not create a new Book' do
        expect do
          post books_path, params: { book: { summary: nil, author: 'Person' } }
        end.not_to change(Book, :count)
      end
    end

    context 'with empty author' do
      it 'does not create a new Book' do
        expect do
          post books_path, params: { book: { title: 'Book A', summary: 'Book A summary', author: nil } }
        end.not_to change(Book, :count)
      end
    end

    context 'with correct params' do
      it 'creates a new Book' do
        expect do
          post books_path, params: { book: { title: 'Book A', summary: 'Book A summary', author: 'Person' } }
        end.to change(Book, :count).by(1)
      end

      it 'redirects to the created Book' do
        post books_path, params: { book: { title: 'Book A', summary: 'Book A summary', author: 'Person' } }
        expect(response).to redirect_to(Book.last)
      end
    end
  end

  describe 'PATCH /books/:id' do
    context 'with invalid title' do
      it 'does not update the Book' do
        book = Book.create! title: 'Book A', summary: 'Book A summary', author: 'Person'
        patch book_path(book), params: { book: { title: nil } }
        book.reload
        expect(book.title).to eq('Book A')
      end
    end

    context 'with invalid summary' do
      it 'does not update the Book' do
        book = Book.create! title: 'Book A', summary: 'Book A summary', author: 'Person'
        patch book_path(book), params: { book: { summary: nil } }
        book.reload
        expect(book.summary).to eq('Book A summary')
      end
    end

    context 'with invalid author' do
      it 'does not update the Book' do
        book = Book.create! title: 'Book A', summary: 'Book A summary', author: 'Person'
        patch book_path(book), params: { book: { author: nil } }
        book.reload
        expect(book.summary).to eq('Book A summary')
      end
    end

    context 'with valid title' do
      it 'updates the Book' do
        book = Book.create! title: 'Book A', summary: 'Book A summary', author: 'Person'
        patch book_path(book), params: { book: { title: 'Book A (revisit)' } }
        book.reload
        expect(book.title).to eq('Book A (revisit)')
      end
    end

    context 'with valid summary' do
      it 'updates the Book' do
        book = Book.create! title: 'Book A', summary: 'Book A summary', author: 'Person'
        patch book_path(book), params: { book: { summary: 'Longer summary' } }
        book.reload
        expect(book.summary).to eq('Longer summary')
      end
    end
  end
end
