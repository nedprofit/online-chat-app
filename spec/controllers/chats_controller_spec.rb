require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit, params: { id: user.to_param }
      expect(response).to be_successful
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { email: 'newemail@example.com' } }

      it 'updates the requested user' do
        put :update, params: { id: user.to_param, user: new_attributes }
        user.reload
        expect(user.email).to eq('newemail@example.com')
      end

      it 'redirects to the user' do
        put :update, params: { id: user.to_param, user: new_attributes }
        expect(response).to redirect_to(user_path)
      end
    end

    context 'with invalid params' do
      it 'returns a success response (i.e., to display the edit template)' do
        put :update, params: { id: user.to_param, user: { email: 'invalidemail' } }, format: :turbo_stream
        expect(response).to be_successful # ожидается рендеринг :edit
      end
    end
  end

end
