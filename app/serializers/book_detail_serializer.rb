# frozen_string_literal: true

class BookDetailSerializer < BookSerializer
  has_many :borrowings, serializer: BorrowingSerializer
end
