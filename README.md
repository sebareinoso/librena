# README

## Requirements
- Ruby 3.4.2
- Rails 8.0.2

The ruby version can be installed using rbenv (recommended) or rvm.

## Dev steps
- Install the correct ruby version.
- Once that is done, run the following commands:
  - `bundle`
  - `yarn`
- Run the `rails db:create` and `rails db:migrate` commands. If `rails db:create` fails, manually create
the `librena_development` database using `PSQL` or similar database method and after run again `rails db:migrate`
- Using the `rails c` command launch the rails console. Create a user with the `admin: true` field.
- If the steps above were successful, run `bin/dev` to start developing.
- There are no background jobs.

## Structure
This is an app as a exercise for an interview. As such, the minimal code was written to ensure functionality.
There are 3 key models:

- User
- Book
- Review

Each user can leave one review per book in the system. A book can have multiple reviews.
A review consists of a score (1 through 5 stars) and an optional comment, with a max of 1000 characters.
If a user is banned, their review does not count towards the book rating global average.

## Tests
All the tests are found inside the `spec/` folder. There are two kinds of tests:

- Model tests: run by typing the command `bundle exec rspec spec/models/{MODEL_NAME}`
- Request tests: run by typing the command `bundle exec rspec spec/requests/{REQUEST_NAME}`

## Data
The database can be populated using the Faker gem included in the `gemfile`.
Simply enter in a terminal and type `rails c` to get into the rails console and use the
Faker documentation to create Books and Users.
