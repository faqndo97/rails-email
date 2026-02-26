require "bundler/setup"
require "bundler/gem_tasks"

desc "Start the dummy app at http://localhost:3000/rails/mailers"
task :server do
  exec "bundle exec rails server", chdir: File.expand_path("test/dummy", __dir__)
end

desc "Open the mailer previews in the browser (starts server first)"
task :preview => :server
