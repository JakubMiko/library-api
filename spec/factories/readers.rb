# frozen_string_literal: true

FactoryBot.define do
  factory :reader do
    card_number { Faker::Number.unique.number(digits: 6).to_s }
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
  end
end
