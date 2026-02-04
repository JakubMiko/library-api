# frozen_string_literal: true

class BorrowBookService
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    validation = Borrowings::CreateContract.new.call(params)
    return { success: false, errors: validation.errors.to_h } if validation.failure?

    book = Book.active.find(validation[:book_id])
    reader = Reader.find_by!(card_number: validation[:reader_card_number])

    borrowing = Borrowing.create!(
      book: book,
      reader: reader,
      borrowed_at: Time.current,
      due_date: Time.current + Borrowing::LOAN_PERIOD_DAYS.days
    )

    schedule_reminders(borrowing)

    { success: true, borrowing: borrowing }
  end

  private

  def schedule_reminders(borrowing)
    BorrowingReminderJob.set(wait_until: borrowing.due_date - 3.days).perform_later(borrowing.id, :reminder)
    BorrowingReminderJob.set(wait_until: borrowing.due_date).perform_later(borrowing.id, :due_today)
  end
end
