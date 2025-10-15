# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'validations' do
    it 'is not valid without title' do
      book = described_class.new(summary: 'Book A summary')

      aggregate_failures do
        expect(book).not_to be_valid
        expect(book.errors[:title]).to include("can't be blank")
      end
    end

    it 'is not valid without summary' do
      book = described_class.new(title: 'Book A')

      aggregate_failures do
        expect(book).not_to be_valid
        expect(book.errors[:summary]).to include("can't be blank")
      end
    end

    it 'is not valid with a title shorter than 2 characters' do
      book = described_class.new(title: 'A', summary: 'Book A summary')

      aggregate_failures do
        expect(book).not_to be_valid
        expect(book.errors[:title]).to include('is too short (minimum is 2 characters)')
      end
    end
  end
end
