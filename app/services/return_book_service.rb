# frozen_string_literal: true

class ReturnBookService
  attr_reader :borrowing_id

  def initialize(borrowing_id)
    @borrowing_id = borrowing_id
  end

  def call
    borrowing = Borrowing.find(borrowing_id)

    if borrowing.returned_at.present?
      return { success: false, error: "Book has already been returned" }
    end

    borrowing.update!(returned_at: Time.current)

    { success: true, borrowing: borrowing }
  end
end
