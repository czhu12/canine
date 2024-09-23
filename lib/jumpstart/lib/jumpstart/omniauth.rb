# Gem names are usually "google-oauth2"
# Provider names are usually "google_oauth2" because symbols don't support hyphens

module Jumpstart
  module Omniauth
    autoload :Callbacks, 'jumpstart/omniauth/callbacks'

    AVAILABLE_PROVIDERS = {
      'facebook' => {
        name: 'Facebook',
        scope: 'email',
        provider: :facebook,
        icon: :facebook
      },
      'github' => {
        name: 'GitHub',
        scope: 'user:email',
        provider: :github,
        icon: :github
      },
      'google-oauth2' => {
        name: 'Google',
        provider: :google_oauth2,
        icon: :google
      },
      'microsoft_graph' => {
        name: 'Microsoft',
        provider: :microsoft_graph,
        icon: :microsoft
      },
      'twitter' => {
        name: 'Twitter',
        provider: :twitter,
        icon: :twitter
      },
      'digitalocean' => {
        name: 'Digital Ocean',
        provider: :digitalocean,
        icon: :digitalocean
      }
    }.freeze

    def self.all_providers
      AVAILABLE_PROVIDERS
    end

    def self.enabled_providers
      enabled = {}
      AVAILABLE_PROVIDERS.each do |gem_name, details|
        next unless enabled?(gem_name)

        provider = details[:provider]
        default_options = {}
        default_options[:scope] = details[:scope] if details[:scope]

        enabled[provider] = {
          public_key: credentials_for(provider).dig(:public_key),
          private_key: credentials_for(provider).dig(:private_key),
          options: default_options.merge(options_for(provider))
        }
      end

      enabled
    end

    # Takes the provider's provider name instead of gem name because it's underscored
    def self.enabled?(gem_name)
      Jumpstart.config.omniauth_providers.include?(gem_name) &&
        has_credentials?(gem_name)
    end

    def self.has_credentials?(gem_name)
      provider = AVAILABLE_PROVIDERS.dig(gem_name, :provider)
      credentials_for(provider).dig(:public_key).present? &&
        credentials_for(provider).dig(:private_key).present?
    end

    # Look up credentials for a provider (assumes an underscored name), ENV variables take precedence
    # omniauth:
    #   github:
    #     private_key: x
    #     public_key: y
    def self.credentials_for(provider)
      credentials = Jumpstart.credentials.dig(Rails.env, :omniauth, provider) ||
                    Jumpstart.credentials.dig(:omniauth, provider)
      credentials.merge({
        private_key: ENV["OMNIAUTH_#{provider.upcase}_PRIVATE_KEY"],
        public_key: ENV["OMNIAUTH_#{provider.upcase}_PUBLIC_KEY"]
      }.compact)
    end

    # Returns a hash of all the other keys and values in the omniauth hash for this provider
    def self.options_for(provider)
      credentials_for(provider).except(:public_key, :private_key)
    end
  end
end
