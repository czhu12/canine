class Integrations::Github::RepositoriesController < ApplicationController
  def index
    # Preference the github provider
    provider = current_user.providers.where(provider: [ Provider::GITHUB_PROVIDER, Provider::GITHUB_APP_PROVIDER ]).first

    client = Octokit::Client.new(bearer_token: provider.access_token)

    if provider.github?
      @repositories = client.repos(provider.username)
      @repositories = @repositories.select { |repo| repo.full_name.downcase.include?(params[:q].downcase) }
    else
      @repositories = client.list_app_installation_repositories[:repositories]
    end

    respond_to do |format|
      format.turbo_stream do
        if params[:page].to_i == 1 || params[:q].present?
          render turbo_stream: turbo_stream.update(
            "repositories-list",
            partial: "index",
            locals: { repositories: @repositories }
          )
        else
          render turbo_stream: turbo_stream.append(
            "repositories-list",
            partial: "index",
            locals: { repositories: @repositories }
          )
        end
      end
    end
  end
end
