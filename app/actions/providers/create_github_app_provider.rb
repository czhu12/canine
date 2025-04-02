class Providers::CreateGithubAppProvider
  extend LightService::Action

  expects :current_user, :installation_id
  promises :provider

  executed do |context|
    Github::App::Client.new.installation_exists?(context.installation_id)
    # Needs to check that an installation exists for the current user
    provider = Provider.new(
      user: context.current_user,
      provider: Provider::GITHUB_APP_PROVIDER,
      auth: {
        info: {
          username: context.current_user.username,
        },
        installation_id: context.installation_id
      }.to_json
    )
    context.provider = provider
  end
end
