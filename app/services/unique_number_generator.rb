# frozen_string_literal: true

class UniqueNumberGenerator
  class LimitExceededError < StandardError; end

  MAX_NUMBERS = 1_000_000

  attr_reader :model, :field

  def initialize(model:, field:)
    @model = model
    @field = field
  end

  def call
    raise LimitExceededError, "Number pool exhausted" if model.count >= MAX_NUMBERS

    loop do
      number = format("%06d", SecureRandom.random_number(MAX_NUMBERS))
      return number unless model.exists?(field => number)
    end
  end
end
