# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'validations' do
    context 'when title is missing' do
      it 'is invalid' do
        book = described_class.new summary: 'Book A summary', author: 'Person'
        expect(book).not_to be_valid
      end
    end

    context 'when summary is missing' do
      it 'is invalid' do
        book = described_class.new title: 'Book A', author: 'Person'
        expect(book).not_to be_valid
      end
    end

    context 'when author is missing' do
      it 'is invalid' do
        book = described_class.new title: 'Book A', summary: 'Book A summary', author: nil
        expect(book).not_to be_valid
      end
    end

    context 'when title is too short (minimum is 2 characters)' do
      it 'is invalid' do
        book = described_class.new title: 'A', summary: 'A summary', author: 'Person'
        expect(book).not_to be_valid
      end
    end

    context 'when title empty (minimum is 2 characters)' do
      it 'is invalid' do
        book = described_class.new title: '', summary: 'A summary', author: 'Person'
        expect(book).not_to be_valid
      end
    end

    context 'when params are correct' do
      it 'is valid' do
        book = described_class.new title: 'Ii', summary: 'A book about Finland', author: 'Noora Piiri'
        expect(book).to be_valid
      end
    end
  end
end
