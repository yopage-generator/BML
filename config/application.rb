require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Bml
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Moscow'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ru

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    config.autoload_paths += Dir[
      "#{Rails.root}/app/api/concerns",
      "#{Rails.root}/app/errors/concerns",
      "#{Rails.root}/app/validators",
      "#{Rails.root}/app/errors",
      "#{Rails.root}/app/form_objects",
      "#{Rails.root}/app/value_objects",
      "#{Rails.root}/app/commands",
      "#{Rails.root}/app/queries",
      "#{Rails.root}/app/utils",
      "#{Rails.root}/app/notifiers",
      "#{Rails.root}/app/notifiers/concerns",
      "#{Rails.root}/app/workers"
    ]

    config.middleware.insert_before 0, 'Rack::Cors' do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :put, :post, :delete, :options]
      end
    end

    config.react.server_renderer_pool_size ||= 1
    config.react.server_renderer_time ||= 10
    config.react.server_renderer = React::ServerRendering::SprocketsRenderer
    # config.react.server_renderer = React::ServerRendering::ExecJSRenderer
    config.react.server_renderer_options = {
      files: ['react-server.js', 'viewer-prerender.js'],
      # Если поставить true то падает JS ошибка про SyntaxError: Invalid escape in identifier: '\'
      replay_console: false
    }
  end
end
