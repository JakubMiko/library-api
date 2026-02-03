# frozen_string_literal: true

readers = 5.times.map do
  Reader.create!(
    card_number: Faker::Number.unique.number(digits: 6).to_s,
    name: Faker::Name.name,
    email: Faker::Internet.unique.email
  )
end

books = 10.times.map do
  Book.create!(
    serial_number: Faker::Number.unique.number(digits: 6).to_s,
    title: Faker::Book.title,
    author: Faker::Book.author
  )
end

Borrowing.create!(book: books[0], reader: readers[0], borrowed_at: 5.days.ago, due_date: 25.days.from_now)
Borrowing.create!(book: books[1], reader: readers[1], borrowed_at: 25.days.ago, due_date: 5.days.from_now)

Borrowing.create!(book: books[2], reader: readers[0], borrowed_at: 45.days.ago, due_date: 15.days.ago, returned_at: 10.days.ago)
Borrowing.create!(book: books[3], reader: readers[1], borrowed_at: 40.days.ago, due_date: 10.days.ago, returned_at: 5.days.ago)

puts "Created #{Reader.count} readers, #{Book.count} books and #{Borrowing.count} borrowings"
