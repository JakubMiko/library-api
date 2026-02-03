# frozen_string_literal: true

class Borrowing < ApplicationRecord
  belongs_to :book
  belongs_to :reader
end
