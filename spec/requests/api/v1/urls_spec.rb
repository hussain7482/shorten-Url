require 'swagger_helper'

RSpec.describe 'API::V1::Urls', type: :request do
  path '/api/v1/urls' do
    post 'Create a short URL' do
      tags 'URL Shortener'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :url_params, in: :body, schema: {
        type: :object,
        properties: {
          url: {
            type: :object,
            properties: {
              original_url: { type: :string, example: 'https://example.com' }
            },
            required: ['original_url']
          }
        },
        required: ['url']
      }
      security [bearer_auth: []]

      response '201', 'URL created' do
        let(:headers) { { 'Authorization' => ENV['API_TOKEN'] } }
        let(:url_params) { { url: { original_url: 'https://example.com' } } }
        run_test!
      end

      response '422', 'Invalid URL' do
        let(:headers) { { 'Authorization' => ENV['API_TOKEN'] } }
        let(:url_params) { { url: { original_url: '' } } }

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { 'InvalidToken' }
        let(:url_params) { { url: { original_url: 'https://example.com' } } }
        let(:headers) { { 'Authorization' => "none" } }

        run_test!
      end
    end
  end
end