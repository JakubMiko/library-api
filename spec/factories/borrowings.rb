# frozen_string_literal: true

FactoryBot.define do
  factory :borrowing do
    book
    reader
    borrowed_at { Time.current }
    due_date { Borrowing::LOAN_PERIOD_DAYS.days.from_now }
    returned_at { nil }

    trait :returned do
      returned_at { Time.current }
    end
  end
end
