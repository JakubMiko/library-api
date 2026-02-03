# frozen_string_literal: true

class Reader < ApplicationRecord
  has_many :borrowings, dependent: :restrict_with_error
end
