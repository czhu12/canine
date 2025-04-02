class Github::App::Client
  CLOCK_DRIFT_SECONDS = 60
  JWT_EXPIRATION_SECONDS = 10.minutes.to_i
  JWT_ALGORITHM = "RS256"

  GITHUB_APP_ID = ENV['GITHUB_APP_ID']
  GITHUB_APP_NAME = ENV['GITHUB_APP_NAME']
  GITHUB_APP_CLIENT_ID = ENV['GITHUB_APP_CLIENT_ID']
  GITHUB_APP_PEM = ENV['GITHUB_APP_PEM']

  def self.update_installation_url(installation_id)
    "https://github.com/settings/installations/#{installation_id}"
  end

  def self.install_url_for_user(user)
    signed_id = user.to_sgid(expires_in: 10.minutes).to_s
    "https://github.com/apps/#{GITHUB_APP_NAME}/installations/new?state=#{signed_id}"
  end

  def self.create_client_for_installation(installation_id)
    app_client = new
    installation_client = Octokit::Client.new(bearer_token: app_client.jwt)
    token = installation_client.create_app_installation_access_token(installation_id)[:token]
    Octokit::Client.new(bearer_token: token)
  end

  def jwt
    JWT.encode(jwt_payload, private_key, JWT_ALGORITHM)
  end

  def installation_exists?(installation_id)
    client = Octokit::Client.new(bearer_token: jwt)
    client.installation(installation_id)
  rescue Octokit::NotFound
    false
  end

  private

  def jwt_payload
    current_time = Time.now.to_i
    {
      iat: current_time - CLOCK_DRIFT_SECONDS,
      exp: current_time + JWT_EXPIRATION_SECONDS,
      iss: GITHUB_APP_CLIENT_ID
    }
  end

  def private_key
    OpenSSL::PKey::RSA.new(GITHUB_APP_PEM)
  end
end
