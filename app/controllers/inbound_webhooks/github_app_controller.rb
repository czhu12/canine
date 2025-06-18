module InboundWebhooks
  class GithubAppController < ApplicationController
    def create
      Rails.logger.info(params.to_json)
    end

    def callback
      signed_id = params[:state]
      user = GlobalID::Locator.locate_signed(signed_id)
      raise StandardError, "User not found" unless user.present?
      Providers::CreateOrUpdateGithubAppProvider.execute(
        current_user: user,
        installation_id: params[:installation_id],
      )
      redirect_to new_project_path, notice: "GitHub App was successfully connected."
    end
  end
end
