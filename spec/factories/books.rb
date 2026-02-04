# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    serial_number { Faker::Number.unique.number(digits: 6).to_s }
    title { Faker::Book.title }
    author { Faker::Book.author }
  end
end
