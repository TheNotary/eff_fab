require File.expand_path('../boot', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EffFab
  class Application < Rails::Application

    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: false,
        request_specs: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    warn "WARNING:  Timezone wasn't set via env/ application.yml" unless ENV['time_zone']
    config.time_zone = ENV['time_zone'] || "Pacific Time (US & Canada)"

    # Shared ActionMailer Configs

    config.action_mailer.smtp_settings = {
      address: ENV['mail_server'],
      port: ENV['mail_port'].to_i,
      domain: ENV['mail_from_domain'],
      authentication: ENV['mail_authentication'].try(:to_sym),
      enable_starttls_auto: ENV['mail_enable_starttls_auto'],
      user_name: ENV['mail_user_name'],
      password: ENV['mail_password']
    }

    config.action_mailer.default_url_options = { host: ENV['domain_name'], protocol: ENV['mail_link_protocol'] }
    config.action_mailer.delivery_method = ENV['mail_delivery_method'].try(:to_sym)

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
  end
end
