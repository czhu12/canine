require 'rails_helper'

FactoryBot.define do
  factory :environment_variable do
    association :project
    name { "ENV_VAR_NAME" }
    value { "SomeValue" }
  end
end