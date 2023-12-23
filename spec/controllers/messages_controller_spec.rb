require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let(:user) { create(:user) }
  let(:chat) { create(:chat) }
  let(:valid_attributes) { { body: 'Test message' } }

  before do
    sign_in user
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Message' do
        expect {
          post :create, params: { chat_id: chat.id, message: valid_attributes }, format: :turbo_stream
        }.to change(Message, :count).by(1)
      end

      it 'redirects to the chat' do
        post :create, params: { chat_id: chat.id, message: valid_attributes }, format: :html
        expect(response).to redirect_to(chat)
      end
    end

    context 'with invalid params' do
      it 'redirects to the chat' do
        post :create, params: { chat_id: chat.id, message: { body: '' } }, format: :html
        expect(response).to redirect_to(chat)
      end
    end
  end

  describe 'GET #show' do
    let(:message) { create(:message, chat: chat, user: user) }

    it 'returns a success response' do
      get :show, params: { chat_id: chat.id, id: message.id }, format: :html
      expect(response).to be_successful
    end
    end
end
