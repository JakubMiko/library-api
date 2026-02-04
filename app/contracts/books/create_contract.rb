# frozen_string_literal: true

module Books
  class CreateContract < ApplicationContract
    params do
      required(:title).filled(:string)
      required(:author).filled(:string)
      optional(:serial_number).filled(:string)
    end

    rule(:serial_number) do
      key.failure("must be exactly 6 digits") if value && !value.match?(/\A\d{6}\z/)
    end
  end
end
