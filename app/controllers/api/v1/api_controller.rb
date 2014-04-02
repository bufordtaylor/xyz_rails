class Api::V1::ApiController < ApplicationController

  API_ERROR_CODES_AND_STATUSES_AND_DESCRIPTION = {
    "0000"  => {status: 500, description: "Internal error"},
    "1000"  => {status: 404, description: "Resource doesn't exist."},
    "2000"  => {status: 400, description: "Invalid argument"},
  }

  unless Rails.env.test?
    rescue_from StandardError do |exception|
      render_api_error("0000")

      # ExceptionNotifier.notify_exception(exception)
    end
  end

  skip_before_action :verify_authenticity_token
  around_action :allow_foreign_requests

  def allow_foreign_requests
    headers["Access-Control-Allow-Origin"] = "*"
    headers["Access-Control-Request-Method"] = "*"
    headers["Access-Control-Allow-Headers"] = "User-Agent, Content-type"
    if request.method == "OPTIONS"
      render nothing: true
      return false
    else
      yield
    end
  end

  def render_api_error(code, description = nil)
    codes_and_statuses_and_descriptions = API_ERROR_CODES_AND_STATUSES_AND_DESCRIPTION

    description_to_render = (description or codes_and_statuses_and_descriptions[code][:description])
    status_to_answer = codes_and_statuses_and_descriptions[code][:status]

    render json: {
      status: "error",
      error: {
        code: code,
        description: description_to_render
      }
    }, status: status_to_answer
  end

  def render_api_success(other_content = {})
    render json: {
      status: "success"
    }.merge(other_content), status: 200
  end

end
