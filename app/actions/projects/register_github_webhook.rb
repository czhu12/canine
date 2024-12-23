class Projects::RegisterGithubWebhook
  extend LightService::Action
  WEBHOOK_SECRET = ENV["OMNIAUTH_GITHUB_WEBHOOK_SECRET"]

  expects :project
  promises :project

  executed do |context|
    client = Octokit::Client.new(access_token: context.project.github_access_token)
    client.create_hook(
      context.project.repository_url,
      "web",
      {
        url: Rails.application.routes.url_helpers.inbound_webhooks_github_index_url,
        content_type: "json",
        secret: webhook_secret
      },
      {
        events: [ "push" ],
        active: true
      }
    )
  rescue Octokit::UnprocessableEntity => e
    next context if e.message.include?("Hook already exists")
    context.fail_and_return!("Failed to create webhook")
  end

  def self.webhook_secret
    return WEBHOOK_SECRET if WEBHOOK_SECRET.present?
    credentials = Rails.application.credentials.dig(Rails.env, :github) || {}
    credentials[:webhook_secret]
  end
end
