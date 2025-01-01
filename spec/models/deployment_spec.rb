# Autogenerated by autotester

require 'rails_helper'

RSpec.describe Deployment, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:build) }
    it { is_expected.to have_one(:project).through(:build) }
    it { is_expected.to have_one(:log_output).dependent(:destroy) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:status).with_values(in_progress: 0, completed: 1, failed: 2) }
  end

  describe 'callbacks' do
    let(:deployment) { create(:deployment) }

    it 'creates a log_output after create' do
      expect(deployment.log_output).not_to be_nil
    end
  end

  describe 'loggable module' do
    let(:deployment) { create(:deployment) }

    before do
      allow(Rails.logger).to receive(:info)
    end

    describe '#info' do
      it 'logs an info message with the correct color' do
        deployment.info('Test message', color: :blue)
        expect(deployment.log_output.output).to include("\e[34mTest message\e[0m")
      end
    end

    describe '#error' do
      it 'logs an error message in red' do
        deployment.error('Error message')
        expect(deployment.log_output.output).to include("\e[31mError message\e[0m")
      end
    end

    describe '#success' do
      it 'logs a success message in green' do
        deployment.success('Success message')
        expect(deployment.log_output.output).to include("\e[32mSuccess message\e[0m")
      end
    end
  end
end
