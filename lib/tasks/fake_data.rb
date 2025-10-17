# lib/tasks/fake_seed.rake
require 'faker'

namespace :fake do
  desc 'Creates fake data for Librena'
  task seed: :environment do
    # Safety: only run in non-production by default (you can remove this check if you really want to run in production)
    if Rails.env.production?
      puts 'DO NOT run in production.'
      exit 1
    end

    Faker::UniqueGenerator.clear

    puts 'Starting fake seeding...'

    # --------- USERS ----------
    admin_attrs = {
      username: 'admin',
      email: 'admin@mail.com',
      password: '123456',
      admin: true
    }

    admin = User.find_or_initialize_by(username: admin_attrs[:username])
    admin.email = admin_attrs[:email]
    admin.password = admin_attrs[:password]
    admin.admin = admin_attrs[:admin]
    admin.save!
    puts "Upserted admin: #{admin.username} (#{admin.email})"

    user_count = 100
    created_users = []
    attempts = 0
    puts "Creating #{user_count} non-admin users..."

    while created_users.size < user_count && attempts < user_count * 5
      attempts += 1
      username = Faker::Internet.unique.username(specifier: 5..12)
      email = Faker::Internet.unique.safe_email(name: username)
      user = User.find_or_initialize_by(username: username)
      next if user.persisted? && user.email.present?

      user.email = email
      user.password = '123456'
      user.save!
      created_users << user
    end

    if created_users.size < user_count
      puts "\nWarning: only created #{created_users.size} users (attempted #{attempts} times)."
    else
      puts "\nCreated #{created_users.size} users."
    end

    all_users = User.where.not(id: nil).to_a # includes admin and newly created users

    # --------- BOOKS ----------
    book_count = 100
    puts "Upserting #{book_count} books..."
    Faker::Book.unique.clear
    created_books = []
    attempts = 0

    while created_books.size < book_count && attempts < book_count * 5
      attempts += 1
      title = Faker::Book.unique.title
      title = title.strip
      next if title.length < 2

      summary = Faker::Lorem.paragraph_by_chars(number: 200, supplemental: false)
      author = Faker::Book.author

      book = Book.find_or_initialize_by(title: title)
      book.summary = summary
      book.author = author
      book.save!
      created_books << book
    end

    if created_books.size < book_count
      puts "\nWarning: only upserted #{created_books.size} books (attempted #{attempts} times)."
    else
      puts "\nUpserted #{created_books.size} books."
    end

    all_books = Book.where.not(id: nil).to_a

    # --------- REVIEWS ----------
    review_count = 300
    puts "Creating #{review_count} reviews..."

    created_reviews = 0
    attempts = 0
    max_attempts = review_count * 10

    while created_reviews < review_count && attempts < max_attempts
      attempts += 1
      user = all_users.sample
      book = all_books.sample
      next unless user && book

      rating = rand(1..5)
      comment = Faker::Lorem.paragraphs(number: rand(1..4)).join("\n\n")[0, 1000]
      review = Review.new(user: user, book: book, rating: rating, comment: comment)

      begin
        review.save!
        created_reviews += 1
      rescue ActiveRecord::RecordInvalid => e
        puts 'Review not created.'
        next
      end
    end

    if created_reviews < review_count
      puts "\nWarning: only created #{created_reviews} reviews (attempted #{attempts} times)."
    else
      puts "\nCreated #{created_reviews} reviews."
    end

    puts 'Fake data generation finished.'
    puts "Totals: Users=#{User.count}, Books=#{Book.count}, Reviews=#{Review.count}"
  end
end
