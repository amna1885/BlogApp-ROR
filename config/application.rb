# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

require 'cloudinary'

require 'sidekiq/web'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BlogApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    config.cloudinary = {
      cloud_name: 'dvv93vh8p',
      api_key: '274658269941387',
      api_secret: 'Oa3ISWmOCXDzHm5iK4yqBR1Qy5M'
    }
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.active_storage.service = :cloudinary

    Cloudinary.config_from_url('cloudinary://274658269941387:Oa3ISWmOCXDzHm5iK4yqBR1Qy5M@dvv93vh8p')

    Cloudinary.config do |config|
      config.secure = true
    end
  end
end
