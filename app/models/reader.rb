# frozen_string_literal: true

class Reader < ApplicationRecord
  has_many :borrowings, dependent: :restrict_with_error

  before_create :generate_card_number

  private

  def generate_card_number
    self.card_number = UniqueNumberGenerator.new(model: Reader, field: :card_number).call
  end
end
