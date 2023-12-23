require 'rails_helper'

RSpec.describe 'Api::Messages', type: :request do
  let!(:user) { create(:user, email: "anonymous@example.com") }
  let!(:chat) { create(:chat) }

  describe 'POST /api/chats/:chat_id/messages' do
    context 'with valid parameters' do
      let(:valid_params) { { message: { body: "Hello World" } } }

      it 'creates a new message' do
        expect {
          post api_chat_messages_path(chat), params: valid_params
        }.to change(Message, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { message: { body: "" } } }

      it 'does not create a new message' do
        expect {
          post api_chat_messages_path(chat), params: invalid_params
        }.to change(Message, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
