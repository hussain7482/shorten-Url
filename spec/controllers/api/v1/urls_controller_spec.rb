require 'rails_helper'

RSpec.describe Api::V1::UrlsController, type: :controller do
  let(:valid_url_params) { { url: { original_url: 'https://example.com' } } }
  let(:invalid_url_params) { { url: { original_url: 'invalid-url' } } }
  let(:api_token) { ENV['API_TOKEN'] }

  # Test for the create action
  describe 'POST #create' do
    context 'when the request is authorized' do
      before do
        request.headers['Authorization'] = api_token
      end

      context 'with valid URL' do
        it 'creates a new short URL' do
          expect {
            post :create, params: valid_url_params
          }.to change(Url, :count).by(1)

          # Check the response is successful and returns a short_url
          expect(response).to have_http_status(:created)
          json_response = JSON.parse(response.body)
          expect(json_response['short_url']).to include('http')
        end
      end

      context 'with invalid URL' do
        it 'does not create a new URL and returns errors' do
          expect {
            post :create, params: invalid_url_params
          }.to_not change(Url, :count)

          # Check the response is unprocessable and returns error messages
          expect(response).to have_http_status(:unprocessable_entity)
          json_response = JSON.parse(response.body)
          expect(json_response['error']).to include("Original url is invalid")
        end
      end
    end

    context 'when the request is unauthorized' do
      it 'returns unauthorized error' do
        request.headers['Authorization'] = 'invalid_token'
        post :create, params: valid_url_params
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Unauthorized')
      end
    end
  end
end
