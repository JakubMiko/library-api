# frozen_string_literal: true

module Api
  module V1
    class BooksController < ApplicationController
      def index
        books = Book.active.includes(:current_borrowing)

        render json: BookSerializer.new(books).serializable_hash
      end

      def show
        book = Book.active.includes(borrowings: :reader).find(params[:id])

        render json: BookSerializer.new(book, include: [ :borrowings, :"borrowings.reader" ]).serializable_hash
      end

      def create
        contract = Books::CreateContract.new
        result = contract.call(book_params.to_h)

        if result.failure?
          return render json: { error: "Validation failed", messages: result.errors.to_h }, status: :unprocessable_content
        end

        book = Book.create!(result.to_h)

        render json: BookSerializer.new(book).serializable_hash, status: :created
      end

      def destroy
        book = Book.active.find(params[:id])

        if book.current_borrowing.present?
          return render json: { error: "Cannot delete book that is currently borrowed" }, status: :unprocessable_content
        end

        book.update!(deleted_at: Time.current)
        head :no_content
      end

      private

      def book_params
        params.permit(:title, :author)
      end
    end
  end
end
