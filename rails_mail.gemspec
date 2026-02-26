require_relative "lib/rails_mail/version"

Gem::Specification.new do |spec|
  spec.name          = "rails_mail"
  spec.version       = RailsMail::VERSION
  spec.authors       = ["Facundo"]
  spec.summary       = "React Email-style mailer preview UI for Rails"
  spec.description   = "Replaces the /rails/mailers preview UI with a polished React Email-inspired interface, while keeping ActionMailer::Preview classes and routes unchanged."
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 3.1"

  spec.files         = Dir["LICENSE", "README.md", "{lib,app}/**/*"]
  spec.require_paths = ["lib"]
end
