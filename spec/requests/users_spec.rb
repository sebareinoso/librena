# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User', type: :request do
  let(:admin) { User.create! username: 'admin', email: 'admin@test.com', password: '123456', admin: true }
  let(:regular_user) { User.create! username: 'admin', email: 'admin@test.com', password: '123456' }
  let(:user) { User.create! username: 'AntonE', email: 'test@test.com', password: '123456' }

  describe 'GET /users' do
    context 'when user is not authenticated' do
      it 'redirects to sign in page' do
        get users_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when non-admin user is authenticated' do
      before { sign_in regular_user }

      it 'redirects to root path' do
        get users_path
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when admin user is authenticated' do
      before { sign_in admin }

      it 'returns a success response' do
        get users_path
        expect(response).to be_successful
      end
    end

    context 'when there are users' do
      before { sign_in admin }

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
    context 'when user is not authenticated' do
      it 'redirects to sign in page' do
        get users_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when non-admin user is authenticated' do
      before { sign_in regular_user }

      it 'redirects to root path' do
        get users_path
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when admin user is authenticated' do
      before { sign_in admin }

      it 'returns a success response' do
        get user_path(user)
        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /users/:id' do
    context 'when user is not authenticated' do
      it 'redirects to sign in page' do
        get users_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when non-admin user is authenticated' do
      before { sign_in regular_user }

      it 'redirects to root path' do
        get users_path
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid username' do
      before { sign_in admin }

      it 'does not update the User' do
        patch user_path(user), params: { user: { username: nil } }
        user.reload
        expect(user.username).to eq('AntonE')
      end
    end

    context 'with valid username' do
      before { sign_in admin }

      it 'updates the User' do
        patch user_path(user), params: { user: { username: 'MrKrabs' } }
        user.reload
        expect(user.username).to eq('MrKrabs')
      end
    end
  end
end
