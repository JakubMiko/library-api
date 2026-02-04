# frozen_string_literal: true

module Api
  module V1
    class BorrowingsController < ApplicationController
      def create
        result = BorrowBookService.new(borrowing_params.to_h).call

        if result[:success]
          render json: BorrowingSerializer.new(result[:borrowing]).serializable_hash, status: :created
        else
          render json: { error: "Validation failed", messages: result[:errors] }, status: :unprocessable_content
        end
      end

      def update
        result = ReturnBookService.new(params[:id]).call

        if result[:success]
          render json: BorrowingSerializer.new(result[:borrowing]).serializable_hash
        else
          render json: { error: result[:error] }, status: :unprocessable_content
        end
      end

      private

      def borrowing_params
        params.permit(:book_id, :reader_card_number)
      end
    end
  end
end
