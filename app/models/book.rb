# frozen_string_literal: true

class Book < ApplicationRecord
  has_many :borrowings, dependent: :restrict_with_error
end
