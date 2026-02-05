# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "Books API", type: :request do
  path "/api/v1/books" do
    get "List all books" do
      tags "Books"
      produces "application/json"

      response "200", "books found" do
        let!(:books) { create_list(:book, 3) }

        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json["data"].size).to eq(3)
        end
      end
    end

    post "Create a book" do
      tags "Books"
      consumes "application/json"
      produces "application/json"
      parameter name: :book, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          author: { type: :string }
        },
        required: %w[title author]
      }

      response "201", "book created" do
        let(:book) { { title: "Test Book", author: "Test Author" } }

        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json["data"]["attributes"]["title"]).to eq("Test Book")
          expect(json["data"]["attributes"]["serial_number"]).to be_present
        end
      end

      response "422", "validation failed" do
        let(:book) { { title: "", author: "" } }

        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json["error"]).to eq("Validation failed")
        end
      end

      response "503", "number pool exhausted" do
        let(:book) { { title: "Test", author: "Author" } }

        before { allow(Book).to receive(:count).and_return(1_000_000) }

        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json["error"]).to eq("Number pool exhausted")
        end
      end
    end
  end

  path "/api/v1/books/{id}" do
    parameter name: :id, in: :path, type: :integer

    get "Show a book with borrowing history" do
      tags "Books"
      produces "application/json"

      response "200", "book found" do
        let(:book) { create(:book) }
        let!(:borrowing) { create(:borrowing, book: book) }
        let(:id) { book.id }

        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json["data"]["id"]).to eq(book.id.to_s)
          expect(json["included"]).to be_present
        end
      end

      response "404", "book not found" do
        let(:id) { 999999 }

        run_test!
      end
    end

    delete "Delete a book" do
      tags "Books"

      response "204", "book deleted" do
        let(:book) { create(:book) }
        let(:id) { book.id }

        run_test! do
          expect(book.reload.deleted_at).to be_present
        end
      end

      response "404", "book not found" do
        let(:id) { 999999 }

        run_test!
      end

      response "422", "cannot delete borrowed book" do
        let(:book) { create(:book) }
        let!(:borrowing) { create(:borrowing, book: book) }
        let(:id) { book.id }

        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json["error"]).to include("currently borrowed")
        end
      end
    end
  end
end
