# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :set_book

  def index
    @reviews = @book.reviews.includes(:user).order(created_at: :desc)
  end

  def new; end

  def create
    @review = @book.reviews.build(review_params)

    if @review.save
      redirect_to @book, notice: 'Review created successfully.'
    else
      flash.now[:alert] = @review.errors.full_messages.to_sentence
      render 'books/show', status: :unprocessable_entity
    end
  end

  private

  def set_book
    @book = Book.find params[:book_id]
  end

  def review_params
    params.require(:review).permit(:user_id, :rating, :comment)
  end
end
