# frozen_string_literal: true

class Borrowing < ApplicationRecord
  MAX_ACTIVE_PER_READER = 5
  LOAN_PERIOD_DAYS = 30

  belongs_to :book
  belongs_to :reader
end
