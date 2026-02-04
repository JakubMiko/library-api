# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { error: "#{e.model} not found" }, status: :not_found
  end

  rescue_from UniqueNumberGenerator::LimitExceededError do |e|
    render json: { error: e.message }, status: :service_unavailable
  end
end
