require 'rails_helper'

RSpec.describe ChatsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:valid_attributes) { { title: 'Test Chat', description: 'This is a test chat.' } }
  let(:invalid_attributes) { { title: '', description: '' } }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a success response' do
      Chat.create! valid_attributes
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      chat = Chat.create! valid_attributes
      get :show, params: { id: chat.to_param }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Chat' do
        expect {
          post :create, params: { chat: valid_attributes }, format: :turbo_stream
        }.to change(Chat, :count).by(1)
      end
    end

    context 'with invalid params' do
      it 'returns a success response (i.e. to display the "new" template)' do
        post :create, params: { chat: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end
end
