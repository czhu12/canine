require 'rails_helper'

RSpec.describe "Docker Compose Health Check", type: :system do
  it "successfully loads the application homepage" do
    visit root_path
    expect(page).to have_css('body')

    visit rails_health_check_path
    expect(page).to have_css('body')
  end

  it "can add new credentials" do
    visit root_path
    expect(page).to have_text('Please go to Github.com and enter your personal access token below.')
  end
end
