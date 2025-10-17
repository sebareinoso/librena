# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    context 'when username is missing' do
      it 'is not invalid' do
        user = described_class.new email: 'test@test.com', password: '123456'
        expect(user).not_to be_valid
      end
    end

    context 'when username is not unique' do
      it 'is not invalid' do
        described_class.create! username: 'Mr rater', email: 'test@test.com', password: '123456'
        user = described_class.new username: 'Mr rater', email: 'test2@test.com', password: '123456'
        expect(user).not_to be_valid
      end
    end

    context 'when email is missing' do
      it 'is not invalid' do
        user = described_class.new username: 'Mr rater', password: '123456'
        expect(user).not_to be_valid
      end
    end

    context 'when email is not unique' do
      it 'is not invalid' do
        described_class.create! username: 'Mr rater', email: 'test@test.com', password: '123456'
        user = described_class.new username: 'Mrs rater', email: 'test@test.com', password: '123456'
        expect(user).not_to be_valid
      end
    end

    context 'when password is missing' do
      it 'is not invalid' do
        user = described_class.new username: 'Mr rater', email: 'test@test.com', password_confirmation: '123456',
                                   admin: false
        expect(user).not_to be_valid
      end
    end

    context 'when password is too short (min 6 characters)' do
      it 'is not invalid' do
        user = described_class.new username: 'Mr rater', email: 'test@test.com', password: '12345'
        expect(user).not_to be_valid
      end
    end

    context 'when params are corrent and admin is false' do
      it 'is valid' do
        user = described_class.new username: 'Mr rater', email: 'test@test.com', password: '123456', admin: false
        expect(user).to be_valid
      end
    end

    context 'when params are corrent and admin is true' do
      it 'is valid' do
        user = described_class.new username: 'Mr rater', email: 'test@test.com', password: '123456', admin: true
        expect(user).to be_valid
      end
    end
  end
end
