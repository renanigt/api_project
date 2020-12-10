class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  private

  def record_invalid(e)
    render json: e, status: :unprocessable_entity
  end
end
