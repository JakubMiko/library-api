# frozen_string_literal: true

module Borrowings
  class CreateContract < ApplicationContract
    params do
      required(:book_id).filled(:integer)
      required(:reader_card_number).filled(:string)
    end

    rule(:book_id) do
      book = Book.active.find_by(id: value)

      if book.nil?
        key.failure("book not found")
      elsif book.current_borrowing.present?
        key.failure("book is already borrowed")
      end
    end

    rule(:reader_card_number) do
      unless value.match?(/\A\d{6}\z/)
        key.failure("must be exactly 6 digits")
        next
      end

      reader = Reader.find_by(card_number: value)

      if reader.nil?
        key.failure("reader not found")
      elsif Borrowing.where(reader_id: reader.id, returned_at: nil).count >= Borrowing::MAX_ACTIVE_PER_READER
        key.failure("reader has reached maximum borrowing limit (#{Borrowing::MAX_ACTIVE_PER_READER})")
      end
    end
  end
end
