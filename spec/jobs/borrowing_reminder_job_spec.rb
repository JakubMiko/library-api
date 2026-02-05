# frozen_string_literal: true

require "rails_helper"

RSpec.describe BorrowingReminderJob do
  describe "#perform" do
    let(:borrowing) { create(:borrowing) }
    let(:mailer) { instance_double(ActionMailer::MessageDelivery, deliver_now: true) }

    context "with :reminder type" do
      it "sends reminder email for active borrowing" do
        allow(BorrowingMailer).to receive(:reminder).and_return(mailer)
        described_class.new.perform(borrowing.id, :reminder)

        expect(BorrowingMailer).to have_received(:reminder).with(borrowing)
      end
    end

    context "with :due_today type" do
      it "sends due_today email for active borrowing" do
        allow(BorrowingMailer).to receive(:due_today).and_return(mailer)
        described_class.new.perform(borrowing.id, :due_today)

        expect(BorrowingMailer).to have_received(:due_today).with(borrowing)
      end
    end

    context "when borrowing already returned" do
      let(:borrowing) { create(:borrowing, :returned) }

      it "does not send email" do
        allow(BorrowingMailer).to receive(:reminder)
        described_class.new.perform(borrowing.id, :reminder)

        expect(BorrowingMailer).not_to have_received(:reminder)
      end
    end

    context "when borrowing not found" do
      it "does not send email" do
        allow(BorrowingMailer).to receive(:reminder)
        described_class.new.perform(999999, :reminder)

        expect(BorrowingMailer).not_to have_received(:reminder)
      end
    end
  end
end
