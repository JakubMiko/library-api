# frozen_string_literal: true

class BookSerializer < ApplicationSerializer
  attributes :serial_number, :title, :author

  attribute :available do |book|
    book.current_borrowing.nil?
  end

  has_many :borrowings, serializer: BorrowingSerializer
end
