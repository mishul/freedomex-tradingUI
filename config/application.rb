require_relative 'boot'

require 'rails'
require 'active_support/all'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FreedomexTradingUI
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.enforce_available_locales = false

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[root.join('config', 'locales', '*.{yml}')]
    config.i18n.available_locales = ['en']

    # Automatically load and reload constants from "lib/*":
    #   lib/aasm/locking.rb => AASM::Locking
    # We disable eager load here since lib contains lot of stuff which is not required for typical app functions.
    config.paths.add 'lib', eager_load: false, autoload: true

    # Automatically load and reload constants from "lib/freedomex_trading_ui/*":
    #   lib/freedomex_trading_ui/foo/bar/baz.rb => Bar::Baz
    # We disable eager load here since lib/freedomex_trading_ui contains lot of stuff which is not required for typical app functions.
    config.paths.add 'lib/freedomex_trading_ui', eager_load: false, autoload: true, glob: '*'

    # Explicitly require "lib/freedomex_trading_ui.rb".
    # require_dependency 'freedomex_trading_ui'
    # config.middleware.insert(0, Rack::ReverseProxy) do
    #  reverse_proxy_options preserve_host: true
    #  reverse_proxy '/trading/*', 'http://localhost:5000'

  end
end
