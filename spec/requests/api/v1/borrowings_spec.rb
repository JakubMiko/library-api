# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "Borrowings API", type: :request do
  path "/api/v1/borrowings" do
    post "Borrow a book" do
      tags "Borrowings"
      consumes "application/json"
      produces "application/json"
      parameter name: :borrowing, in: :body, schema: {
        type: :object,
        properties: {
          book_id: { type: :integer },
          reader_card_number: { type: :string }
        },
        required: %w[book_id reader_card_number]
      }

      response "201", "book borrowed" do
        let(:book) { create(:book) }
        let(:reader) { create(:reader) }
        let(:borrowing) { { book_id: book.id, reader_card_number: reader.card_number } }

        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json["data"]["attributes"]["due_date"]).to be_present
        end
      end

      response "422", "book already borrowed" do
        let(:book) { create(:book) }
        let(:reader) { create(:reader) }
        let!(:existing) { create(:borrowing, book: book) }
        let(:borrowing) { { book_id: book.id, reader_card_number: reader.card_number } }

        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json["messages"]["book_id"]).to include("book is already borrowed")
        end
      end

      response "422", "reader at limit" do
        let(:book) { create(:book) }
        let(:reader) { create(:reader) }
        let!(:existing_borrowings) { 5.times { create(:borrowing, reader: reader) } }
        let(:borrowing) { { book_id: book.id, reader_card_number: reader.card_number } }

        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json["messages"]["reader_card_number"]).to include("reader has reached maximum borrowing limit (5)")
        end
      end

      response "422", "book not found" do
        let(:reader) { create(:reader) }
        let(:borrowing) { { book_id: 999999, reader_card_number: reader.card_number } }

        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json["messages"]["book_id"]).to include("book not found")
        end
      end

      response "422", "reader not found" do
        let(:book) { create(:book) }
        let(:borrowing) { { book_id: book.id, reader_card_number: "999999" } }

        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json["messages"]["reader_card_number"]).to include("reader not found")
        end
      end
    end
  end

  path "/api/v1/borrowings/{id}" do
    parameter name: :id, in: :path, type: :integer

    patch "Return a book" do
      tags "Borrowings"
      produces "application/json"

      response "200", "book returned" do
        let(:existing_borrowing) { create(:borrowing) }
        let(:id) { existing_borrowing.id }

        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json["data"]["attributes"]["returned_at"]).to be_present
        end
      end

      response "422", "book already returned" do
        let(:existing_borrowing) { create(:borrowing, :returned) }
        let(:id) { existing_borrowing.id }

        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json["error"]).to eq("Book has already been returned")
        end
      end

      response "404", "borrowing not found" do
        let(:id) { 999999 }

        run_test!
      end
    end
  end
end
