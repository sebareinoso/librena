# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  before_action :set_book
  before_action :prevent_dupe_review, only: %i[new create]

  def index
    @reviews = @book.reviews.includes(:user).order(created_at: :desc)
  end

  def new; end

  def create
    @review = @book.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      redirect_to @book, notice: 'Review created successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_book
    @book = Book.find params[:book_id]
  end

  def review_params
    params.require(:review).permit(:user_id, :rating, :comment)
  end

  def prevent_dupe_review
    user = @book.reviews.find_by user: current_user
    return unless user.present?

    redirect_to @book, alert: t('views.reviews.already_exists')
  end
end
