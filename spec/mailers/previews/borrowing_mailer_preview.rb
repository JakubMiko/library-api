# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/borrowing_mailer
class BorrowingMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/borrowing_mailer/reminder
  def reminder
    BorrowingMailer.reminder(Borrowing.first)
  end

  # Preview this email at http://localhost:3000/rails/mailers/borrowing_mailer/due_today
  def due_today
    BorrowingMailer.due_today(Borrowing.first)
  end
end
