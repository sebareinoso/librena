# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User', type: :request do
  describe 'GET /users' do
    it 'returns a success response' do
      get users_path
      expect(response).to be_successful
    end

    context 'when there are users' do
      it 'returns a populated @users' do
        user_one = User.create! username: 'AntonE', email: 'test@test.com', password: '123456'
        user_two = User.create! username: 'GordonR', email: 'g@ramsey.com', password: '123456'
        get users_path
        expect(response.body).to include user_one.email
        expect(response.body).to include user_two.email
        expect(response).to have_http_status :ok
      end
    end
  end

  describe 'GET /user/:id' do
    it 'returns a success response' do
      user = User.create! username: 'AntonE', email: 'test@test.com', password: '123456'
      get user_path(user)
      expect(response).to be_successful
    end
  end

  describe 'PATCH /users/:id' do
    context 'with invalid email' do
      it 'does not update the User' do
        user = User.create! username: 'AntonE', email: 'test@test.com', password: '123456'
        patch user_path(user), params: { user: { email: nil } }
        user.reload
        expect(user.email).to eq('test@test.com')
      end
    end

    context 'with valid email' do
      it 'updates the User' do
        user = User.create! username: 'AntonE', email: 'test@test.com', password: '123456'
        patch user_path(user), params: { user: { email: 'test2@test.com' } }
        user.reload
        expect(user.email).to eq('test2@test.com')
      end
    end
  end
end
