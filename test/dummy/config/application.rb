require_relative "boot"

require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"

require "rails_email"

module Dummy
  class Application < Rails::Application
    config.eager_load = false
    config.secret_key_base = "dummy_secret_key_base_not_used_in_production_rails_mail_gem"

    # Serve static files from test/dummy/public
    config.public_file_server.enabled = true

    # Logger
    config.logger = Logger.new($stdout)
    config.log_level = :info

    # Mailer previews
    config.action_mailer.show_previews = true
    config.action_mailer.delivery_method = :test
    config.action_mailer.default_url_options = { host: "localhost", port: 3000 }
    config.action_mailer.preview_paths = [Rails.root.join("test/mailers/previews")]
  end
end
