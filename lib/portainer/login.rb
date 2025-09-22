class Portainer::Login
  extend LightService::Action

  expects :password, :account
  expects :username, default: nil
  expects :provider_url, default: nil
  promises :user, :account, :stack_manager

  executed do |context|
    provider_url = context.provider_url

    if context.account.stack_manager.nil?
      context.stack_manager = context.account.stack_managers.create!(
        stack_manager_type: :portainer,
        provider_url:
      )
    end

    jwt = Portainer::Client.authenticate(
      username: context.username,
      auth_code: context.password,
      provider_url:
    )

    if jwt.nil?
      context.fail_and_return!("Invalid username or password")
    end

    if context.username.blank?
      response = Portainer::Client.new(provider_url, jwt).get("/api/users/me")
      context.username = response.dig("Username")
    end

    context.user = User.find_or_initialize_by(
      email: context.username + "@oncanine.run",
    )

    password = Devise.friendly_token
    context.user.assign_attributes(
      password:,
      password_confirmation: password,
    )
    context.user.save!
    provider = context.user.providers.find_or_initialize_by(provider: "portainer")
    provider.assign_attributes(access_token: jwt)
    provider.save!

    unless context.account.users.include?(context.user)
      context.account.account_users.create!(user: context.user)
    end
  rescue Portainer::Client::ConnectionError => e
    context.fail_and_return!(e.message)
  rescue StandardError => e
    context.user ||= User.new(email: context.username)
    context.fail_and_return!("Authentication failed: #{e.message}")
  end
end
