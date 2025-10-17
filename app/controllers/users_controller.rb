# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :set_user, only: %i[show edit update]

  def index
    @users = User.all.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show; end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find params[:id]
  end

  def user_params
    params.require(:user).permit(:username, :active)
  end

  def check_admin
    redirect_to root_path unless current_user.admin?
  end
end
