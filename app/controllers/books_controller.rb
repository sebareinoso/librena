# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update]

  def index
    @books = Book.all.order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
    @reviews = @book.reviews.order(created_at: :desc).page(params[:page]).per(10)
    @current_user_reviewed = @book.reviews.find_by(user: current_user).present?
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)

    if @book.save
      redirect_to @book, notice: 'Book created successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: 'Book successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_book
    @book = Book.find params[:id]
  end

  def book_params
    params.require(:book).permit(:title, :summary, :author)
  end
end
