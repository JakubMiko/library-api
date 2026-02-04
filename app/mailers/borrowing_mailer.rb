# frozen_string_literal: true

class BorrowingMailer < ApplicationMailer
  def reminder(borrowing)
    @borrowing = borrowing
    @reader = borrowing.reader
    @book = borrowing.book

    mail to: @reader.email, subject: "Reminder: Book return in 3 days"
  end

  def due_today(borrowing)
    @borrowing = borrowing
    @reader = borrowing.reader
    @book = borrowing.book

    mail to: @reader.email, subject: "Reminder: Book return due today"
  end
end
