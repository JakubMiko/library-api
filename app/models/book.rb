# frozen_string_literal: true

class Book < ApplicationRecord
  has_many :borrowings, dependent: :restrict_with_error
  has_one :current_borrowing, -> { where(returned_at: nil) }, class_name: "Borrowing"

  scope :active, -> { where(deleted_at: nil) }

  before_create :generate_serial_number

  private

  def generate_serial_number
    self.serial_number = UniqueNumberGenerator.new(model: Book, field: :serial_number).call
  end
end
