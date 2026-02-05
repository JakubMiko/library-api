# frozen_string_literal: true

require "rails_helper"

RSpec.describe UniqueNumberGenerator do
  describe "#call" do
    subject { described_class.new(model: Book, field: :serial_number).call }

    it "generates unique 6-digit string not in database" do
      create(:book, serial_number: "123456")

      expect(subject).to match(/\A\d{6}\z/)
      expect(subject).not_to eq("123456")
    end

    it "raises LimitExceededError when number pool exhausted" do
      allow(Book).to receive(:count).and_return(1_000_000)

      expect { subject }.to raise_error(UniqueNumberGenerator::LimitExceededError, "Number pool exhausted")
    end
  end
end
