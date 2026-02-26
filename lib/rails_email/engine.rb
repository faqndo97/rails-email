module RailsEmail
  # Isolated module so the method survives Rails code reloading
  module MailersControllerExtension
    def spam_check
      require "net/http"
      require "json"

      find_preview
      email_action = File.basename(params[:path])

      unless @preview.email_exists?(email_action)
        render json: { error: "Email '#{email_action}' not found" }, status: :not_found
        return
      end

      email = @preview.call(email_action, params)
      raw   = email.to_s

      uri  = URI("https://spamcheck.postmarkapp.com/filter")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl     = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER

      # OpenSSL 3.x tries to fetch the CRL for intermediate certs and fails
      # when the distribution point is unreachable (error code 3 =
      # V_ERR_UNABLE_TO_GET_CRL). Skip only that error; enforce everything else.
      crl_err = OpenSSL::X509::V_ERR_UNABLE_TO_GET_CRL rescue 3
      http.verify_callback = proc do |ok, ctx|
        ok || ctx.error == crl_err
      end

      req      = Net::HTTP::Post.new(uri, "Content-Type" => "application/json")
      req.body = { email: raw, options: "long" }.to_json
      res      = http.request(req)
      render json: JSON.parse(res.body)
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  class Engine < ::Rails::Engine
    # Must be prepended so it wins over ActionMailer's wildcard /*path
    initializer "rails_email.routes" do
      Rails.application.routes.prepend do
        get "/rails/mailers/spam_check/*path", to: "rails/mailers#spam_check"
      end
    end

    # to_prepare runs after all initializers + after each code reload in development
    config.to_prepare do
      require "rails/mailers_controller"

      Rails::MailersController.prepend_view_path(
        RailsEmail::Engine.root.join("app/views")
      )
      Rails::MailersController.layout(false)
      Rails::MailersController.include(RailsEmail::MailersControllerExtension)
    end
  end
end
