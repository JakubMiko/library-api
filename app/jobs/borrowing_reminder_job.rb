# frozen_string_literal: true

class BorrowingReminderJob < ApplicationJob
  queue_as :default

  def perform(borrowing_id, reminder_type)
    borrowing = Borrowing.find_by(id: borrowing_id)

    return if borrowing.nil? || borrowing.returned_at.present?

    case reminder_type.to_sym
    when :reminder
      BorrowingMailer.reminder(borrowing).deliver_now
    when :due_today
      BorrowingMailer.due_today(borrowing).deliver_now
    end
  end
end
