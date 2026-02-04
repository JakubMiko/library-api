# frozen_string_literal: true

class ReaderSerializer < ApplicationSerializer
  attributes :card_number, :name, :email

  has_many :borrowings, serializer: BorrowingSerializer
end
