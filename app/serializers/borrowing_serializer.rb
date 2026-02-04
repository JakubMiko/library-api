# frozen_string_literal: true

class BorrowingSerializer < ApplicationSerializer
  attributes :borrowed_at, :due_date, :returned_at

  attribute :book_title do |borrowing|
    borrowing.book.title
  end

  belongs_to :book, serializer: BookSerializer
  belongs_to :reader, serializer: ReaderSerializer
end
