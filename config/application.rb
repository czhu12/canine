require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Canine
  class Application < Rails::Application
    config.assets.css_compressor = nil
    config.local_mode = ENV["LOCAL_MODE"] == "true"
    config.active_job.queue_adapter = :good_job
    config.application_name = Rails.application.class.module_parent_name
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])
    config.i18n.load_path += Dir[Rails.root.join("config/locales/**/*.{rb,yml}")]
    config.after_initialize do |app|
      Rails.application.routes.default_url_options[:host] = ENV["APP_HOST"]
    end

    config.autoload_paths << Rails.root.join("lib")
    config.eager_load_paths << Rails.root.join("lib")
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Enable cron enqueuing in this process
    config.good_job.enable_cron = true

    # Without zero-downtime deploys, re-attempt previous schedules after a deploy
    config.good_job.cron_graceful_restart_period = 1.minute

    # Configure cron with a hash that has a unique key for each recurring job
    config.good_job.cron = {
      fetch_metrics_job: {
        cron: "*/15 * * * *",
        class: "Scheduled::FetchMetricsJob"
      },
      flush_metrics_job: {
        cron: "0 0 * * *",
        class: "Scheduled::FlushMetricsJob"
      },
      check_health_job: {
        cron: "0 0 * * *",
        class: "Scheduled::CheckHealthJob"
      }
    }
  end
end
