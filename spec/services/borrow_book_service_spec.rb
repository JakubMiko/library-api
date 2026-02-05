# frozen_string_literal: true

require "rails_helper"

RSpec.describe BorrowBookService do
  describe "#call" do
    let(:book) { create(:book) }
    let(:reader) { create(:reader) }
    let(:params) { { book_id: book.id, reader_card_number: reader.card_number } }

    subject { described_class.new(params).call }

    context "with valid params" do
      it "creates borrowing, schedules reminders and returns success" do
        expect { subject }.to change(Borrowing, :count).by(1)
                          .and have_enqueued_job(BorrowingReminderJob).exactly(2).times

        expect(subject[:success]).to be true
        expect(subject[:borrowing].book).to eq(book)
        expect(subject[:borrowing].reader).to eq(reader)
        expect(subject[:borrowing].due_date.to_date).to eq(30.days.from_now.to_date)
      end
    end

    context "with invalid book_id" do
      let(:params) { { book_id: 999999, reader_card_number: reader.card_number } }

      it "fails with book not found error" do
        expect { subject }.not_to change(Borrowing, :count)
        expect(subject[:success]).to be false
        expect(subject[:errors][:book_id]).to include("book not found")
      end
    end

    context "when book is already borrowed" do
      let!(:existing_borrowing) { create(:borrowing, book: book) }

      it "fails with already borrowed error" do
        expect { subject }.not_to change(Borrowing, :count)
        expect(subject[:success]).to be false
        expect(subject[:errors][:book_id]).to include("book is already borrowed")
      end
    end

    context "with invalid reader_card_number format" do
      let(:params) { { book_id: book.id, reader_card_number: "abc" } }

      it "fails with format error" do
        expect(subject[:success]).to be false
        expect(subject[:errors][:reader_card_number]).to include("must be exactly 6 digits")
      end
    end

    context "when reader not found" do
      let(:params) { { book_id: book.id, reader_card_number: "999999" } }

      it "fails with reader not found error" do
        expect(subject[:success]).to be false
        expect(subject[:errors][:reader_card_number]).to include("reader not found")
      end
    end

    context "when reader has reached borrowing limit" do
      let!(:existing_borrowings) { 5.times { create(:borrowing, reader: reader) } }

      it "fails with limit error" do
        expect { subject }.not_to change(Borrowing, :count)
        expect(subject[:success]).to be false
        expect(subject[:errors][:reader_card_number]).to include("reader has reached maximum borrowing limit (5)")
      end
    end
  end
end
