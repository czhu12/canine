require 'rails_helper'

RSpec.describe InboundWebhooks::GithubAppController, type: :controller do
  describe '#create' do
    let(:user) { create(:user) }
    let(:signed_id) { user.to_sgid.to_s }
    let(:installation_id) { '123456' }

    context 'with valid parameters' do
      before do
        allow(Providers::CreateGithubAppProvider).to receive(:execute)
      end

      it 'connects GitHub app and redirects to edit registration path' do
        post :create, params: { state: signed_id, installation_id: installation_id }

        expect(response).to redirect_to(edit_user_registration_path)
      end
    end

    context 'with invalid user' do
      it 'raises an error when user is not found' do
        expect {
          post :create, params: { state: 'invalid_signed_id', installation_id: installation_id }
        }.to raise_error(StandardError, 'User not found')
      end
    end
  end
end
