class Providers::CreateOrUpdateGithubAppProvider
  extend LightService::Action

  expects :current_user, :installation_id
  promises :provider

  executed do |context|
    installation = Github::App::Client.new.installation_exists?(context.installation_id)
    context.provider = context.current_user.providers.where(provider: Provider::GITHUB_APP_PROVIDER).find do |p|
      JSON.parse(p.auth)["installation_id"] == context.installation_id
    end
    if context.provider.nil?
      context.provider = Provider.new(
        user: context.current_user,
        provider: Provider::GITHUB_APP_PROVIDER,
      )
    end
    context.provider.assign_attributes(
      access_token: context.installation_id,
      auth: {
        info: {
          username: installation.account.login
        },
        installation_id: context.installation_id
      }.to_json
    )
    context.provider.save!
  end
end
