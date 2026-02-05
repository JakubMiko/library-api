# frozen_string_literal: true

class BookSerializer < ApplicationSerializer
  attributes :serial_number, :title, :author

  attribute :available do |book|
    if book.borrowings.loaded?
      book.borrowings.none? { |b| b.returned_at.nil? }
    else
      book.current_borrowing.nil?
    end
  end
end
