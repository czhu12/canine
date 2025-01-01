# Autogenerated by autotester

require 'rails_helper'

RSpec.describe Build, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to have_one(:deployment).dependent(:destroy) }
    it { is_expected.to have_one(:log_output).dependent(:destroy) }
    it { is_expected.to have_many(:events).dependent(:destroy) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:status).with_values(in_progress: 0, completed: 1, failed: 2) }
  end

  describe 'callbacks' do
    let(:build) { build(:build) }
    
    it 'creates an event after create' do
      allow(build).to receive(:create_event)
      build.save
      expect(build).to have_received(:create_event)
    end
  end

  describe 'Loggable concern' do
    let(:build) { create(:build) }

    describe '#info' do
      it 'logs information with the correct color' do
        expect(Rails.logger).to receive(:info).with("Test info")
        build.info("Test info", color: :green)
        expect(build.log_output.output).to include("\e[32mTest info\e[0m\n")
      end
    end

    describe '#error' do
      it 'logs error in red' do
        build.error("Test error")
        expect(build.log_output.output).to include("\e[31mTest error\e[0m\n")
      end
    end

    describe '#success' do
      it 'logs success in green' do
        build.success("Test success")
        expect(build.log_output.output).to include("\e[32mTest success\e[0m\n")
      end
    end
  end

  describe 'Eventable concern' do
    let(:build) { build(:build, current_user: create(:user)) }

    describe '#create_event' do
      it 'creates an event after saving the build' do
        expect { build.save }.to change { build.events.count }.by(1)
      end

      it 'associates event with the current user' do
        build.save
        expect(build.events.last.user).to eq(build.current_user)
      end
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:commit_sha) }
    it { is_expected.to validate_presence_of(:project_id) }
  end

  describe 'factory' do
    it 'is valid with default attributes' do
      expect(build(:build)).to be_valid
    end

    context 'with :completed trait' do
      it 'has completed status' do
        build = build(:build, :completed)
        expect(build).to be_completed
      end
    end

    context 'with :failed trait' do
      it 'has failed status' do
        build = build(:build, :failed)
        expect(build).to be_failed
      end
    end
  end
end
