# Autogenerated by autotester

require 'rails_helper'

RSpec.describe EnvironmentVariables::BulkUpdate, type: :action do
  let(:project) { create(:project) }
  let(:current_user) { create(:user) }
  let(:context) { LightService::Context.make(project: project, params: params, current_user: current_user) }

  describe '.executed' do
    let(:action) { described_class.execute(context) }

    context 'when there are new environment variables' do
      let(:params) do
        {
          environment_variables: [
            { name: 'NEW_VAR', value: 'new_value' }
          ]
        }
      end

      it 'creates new environment variables' do
        expect { action }.to change { project.environment_variables.count }.by(1)
        expect(project.environment_variables.find_by(name: 'NEW_VAR')).to have_attributes(value: 'new_value')
      end
    end

    context 'when there are existing environment variables to update' do
      let!(:existing_variable) { create(:environment_variable, project: project, name: 'EXISTING_VAR', value: 'old_value') }
      let(:params) do
        {
          environment_variables: [
            { name: 'EXISTING_VAR', value: 'new_value' }
          ]
        }
      end

      it 'updates the value of existing environment variables' do
        expect { action }.to change { existing_variable.reload.value }.from('old_value').to('new_value')
      end

      it 'creates an update event' do
        expect { action }.to change { existing_variable.events.count }.by(1)
        expect(existing_variable.events.last).to have_attributes(user: current_user, event_action: 'update')
      end
    end

    context 'when there are environment variables to be destroyed' do
      let!(:existing_variable) { create(:environment_variable, project: project, name: 'TO_BE_DESTROYED') }
      let(:params) do
        {
          environment_variables: []
        }
      end

      it 'destroys environment variables not present in the incoming data' do
        expect { action }.to change { project.environment_variables.count }.by(-1)
        expect(project.environment_variables.find_by(name: 'TO_BE_DESTROYED')).to be_nil
      end
    end

    context 'when environment variable names are blank' do
      let(:params) do
        {
          environment_variables: [
            { name: '', value: 'some_value' }
          ]
        }
      end

      it 'does not create environment variables with blank names' do
        expect { action }.not_to change { project.environment_variables.count }
      end
    end

    context 'when there are no changes' do
      let!(:existing_variable) { create(:environment_variable, project: project, name: 'EXISTING_VAR', value: 'same_value') }
      let(:params) do
        {
          environment_variables: [
            { name: 'EXISTING_VAR', value: 'same_value' }
          ]
        }
      end

      it 'does not create update events for unchanged variables' do
        expect { action }.not_to change { existing_variable.events.count }
      end
    end
  end
end
