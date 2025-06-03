require 'rails_helper'

RSpec.describe Providers::CreateGithubAppProvider do
  describe '.execute' do
    let(:current_user) { create(:user) }
    let(:installation_id) { '12345' }
    let(:context) do
      {
        current_user: current_user,
        installation_id: installation_id
      }
    end

    it 'stores the installation_id in the auth JSON' do
      result = described_class.execute(context)
      auth_data = JSON.parse(result.provider.auth)

      expect(auth_data['installation_id']).to eq(installation_id)
    end
  end
end
