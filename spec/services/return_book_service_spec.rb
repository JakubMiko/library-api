# frozen_string_literal: true

require "rails_helper"

RSpec.describe ReturnBookService do
  describe "#call" do
    let(:borrowing) { create(:borrowing) }

    subject { described_class.new(borrowing.id).call }

    context "with active borrowing" do
      it "marks borrowing as returned and returns success" do
        expect(subject[:success]).to be true
        expect(subject[:borrowing].returned_at).to be_present
      end
    end

    context "when borrowing already returned" do
      let(:borrowing) { create(:borrowing, :returned) }

      it "fails with already returned error" do
        expect(subject[:success]).to be false
        expect(subject[:error]).to eq("Book has already been returned")
      end
    end

    context "when borrowing not found" do
      it "raises RecordNotFound" do
        expect { described_class.new(999999).call }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
