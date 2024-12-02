class Api::V1::UrlsController < ApplicationController
    protect_from_forgery with: :null_session, only: [:create]
    before_action :authenticate_api_token, only: [:create]

 
  def create
    @url = Url.new(url_params)
    if @url.save
      render json: { short_url: request.base_url + '/' + @url.short_code }, status: :created
    else
      render json: { error: @url.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def url_params
    params.require(:url).permit(:original_url)
  end

  def authenticate_api_token
    token = request.headers['Authorization']
    unless token == "#{ENV['API_TOKEN']}"
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
