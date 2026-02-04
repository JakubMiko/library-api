# frozen_string_literal: true

class BookSerializer < ApplicationSerializer
  attributes :serial_number, :title, :author

  has_many :borrowings, serializer: BorrowingSerializer
end
