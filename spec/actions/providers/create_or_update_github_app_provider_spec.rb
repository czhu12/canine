require 'rails_helper'

RSpec.describe Providers::CreateOrUpdateGithubAppProvider do
  let(:current_user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:installation_id) { '123' }
  let(:installation) { double('installation', account: double('account', login: 'testuser')) }
  let(:github_client) { instance_double(Github::App::Client) }

  before do
    allow(Github::App::Client).to receive(:new).and_return(github_client)
  end

  describe '#execute' do
    context 'when installation does not exist' do
      before do
        allow(github_client).to receive(:installation_exists?).with(installation_id).and_return(nil)
      end

      it 'raises an error' do
        expect {
          described_class.execute(current_user: current_user, installation_id: installation_id)
        }.to raise_error(StandardError)
      end
    end

    context 'when provider does not exist' do
      before do
        allow(github_client).to receive(:installation_exists?).with(installation_id).and_return(installation)
      end

      it 'creates a new provider' do
        result = described_class.execute(current_user: current_user, installation_id: installation_id)

        expect(result.provider).to be_persisted
        expect(result.provider.user).to eq(current_user)
        expect(result.provider.provider).to eq(Provider::GITHUB_APP_PROVIDER)
        expect(JSON.parse(result.provider.auth)['installation_id']).to eq(installation_id)
        expect(JSON.parse(result.provider.auth)['info']['username']).to eq('testuser')
      end
    end

    context 'when provider exists with different installation ID' do
      let!(:existing_provider) do
        create(:provider,
          user: current_user,
          provider: Provider::GITHUB_APP_PROVIDER,
          auth: { installation_id: '456', info: { username: 'olduser' } }.to_json
        )
      end

      before do
        allow(github_client).to receive(:installation_exists?).with(installation_id).and_return(installation)
      end

      it 'creates a new provider' do
        result = described_class.execute(current_user: current_user, installation_id: installation_id)

        expect(result.provider).not_to eq(existing_provider)
        expect(result.provider).to be_persisted
        expect(JSON.parse(result.provider.auth)['installation_id']).to eq(installation_id)
        expect(JSON.parse(result.provider.auth)['info']['username']).to eq('testuser')
      end
    end

    context 'when provider exists with different user' do
      let!(:existing_provider) do
        create(:provider,
          user: other_user,
          provider: Provider::GITHUB_APP_PROVIDER,
          auth: { installation_id: installation_id, info: { username: 'olduser' } }.to_json
        )
      end

      before do
        allow(github_client).to receive(:installation_exists?).with(installation_id).and_return(installation)
      end

      it 'creates a new provider' do
        result = described_class.execute(current_user: current_user, installation_id: installation_id)

        expect(result.provider).not_to eq(existing_provider)
        expect(result.provider).to be_persisted
        expect(result.provider.user).to eq(current_user)
        expect(JSON.parse(result.provider.auth)['installation_id']).to eq(installation_id)
        expect(JSON.parse(result.provider.auth)['info']['username']).to eq('testuser')
      end
    end

    context 'when provider exists with different provider type' do
      let!(:existing_provider) do
        create(:provider,
          user: current_user,
          provider: 'other_provider',
          auth: { installation_id: installation_id, info: { username: 'olduser' } }.to_json
        )
      end

      before do
        allow(github_client).to receive(:installation_exists?).with(installation_id).and_return(installation)
      end

      it 'creates a new provider' do
        result = described_class.execute(current_user: current_user, installation_id: installation_id)

        expect(result.provider).not_to eq(existing_provider)
        expect(result.provider).to be_persisted
        expect(result.provider.provider).to eq(Provider::GITHUB_APP_PROVIDER)
        expect(JSON.parse(result.provider.auth)['installation_id']).to eq(installation_id)
        expect(JSON.parse(result.provider.auth)['info']['username']).to eq('testuser')
      end
    end

    context 'when provider exists with different installation ID and user' do
      let!(:existing_provider) do
        create(:provider,
          user: other_user,
          provider: Provider::GITHUB_APP_PROVIDER,
          auth: { installation_id: '456', info: { username: 'olduser' } }.to_json
        )
      end

      before do
        allow(github_client).to receive(:installation_exists?).with(installation_id).and_return(installation)
      end

      it 'creates a new provider' do
        result = described_class.execute(current_user: current_user, installation_id: installation_id)

        expect(result.provider).not_to eq(existing_provider)
        expect(result.provider).to be_persisted
        expect(result.provider.user).to eq(current_user)
        expect(result.provider.provider).to eq(Provider::GITHUB_APP_PROVIDER)
        expect(JSON.parse(result.provider.auth)['installation_id']).to eq(installation_id)
        expect(JSON.parse(result.provider.auth)['info']['username']).to eq('testuser')
      end
    end

    context 'when provider exists' do
      let!(:existing_provider) do
        create(:provider,
          user: current_user,
          provider: Provider::GITHUB_APP_PROVIDER,
          auth: { installation_id: installation_id, info: { username: 'olduser' } }.to_json
        )
      end

      before do
        allow(github_client).to receive(:installation_exists?).with(installation_id).and_return(installation)
      end

      it 'updates the existing provider' do
        result = described_class.execute(current_user: current_user, installation_id: installation_id)

        expect(result.provider).to eq(existing_provider)
        expect(JSON.parse(result.provider.auth)['info']['username']).to eq('testuser')
      end
    end
  end
end
