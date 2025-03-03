require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsTutorial
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.available_locales = [:en, :vi]
    config.i18n.default_locale = :vi
    # Load config/settings.yml
    config.before_configuration do
      env_file = Rails.root.join("config", "settings.yml")
      if File.exist?(env_file) 
        config_settings = YAML.load_file(env_file)[Rails.env] || {}
        config_settings.each do |key, value|
          ENV[key.to_s.upcase] ||= value.to_s
        end
      end
    end
  end
end
