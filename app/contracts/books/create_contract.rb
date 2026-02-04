# frozen_string_literal: true

module Books
  class CreateContract < ApplicationContract
    params do
      required(:title).filled(:string)
      required(:author).filled(:string)
    end
  end
end
