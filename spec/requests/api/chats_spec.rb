require 'rails_helper'

RSpec.describe 'Api::Chats', type: :request do
  describe 'GET /api/chats' do
    before do
      create_list(:chat, 3)
      get api_chats_path
    end

    it 'returns all chats' do
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(3)
    end

    it 'returns chats in the correct format' do
      expect(response.content_type).to eq("application/json; charset=utf-8")
      json = JSON.parse(response.body)
      expect(json.first).to include("title")
    end
  end
end
