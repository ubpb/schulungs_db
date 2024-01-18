source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby IO.read(".ruby-version").strip

gem "active_flag",       "~> 1.0"
gem "acts_as_list",      "~> 1.1"
gem "bcrypt",            "~> 3.1.7"
gem "bootstrap",         "~> 4.1"
gem "caxlsx_rails",      "~> 0.6.2"
gem "commonmarker",      "~> 0.17"
gem "font-awesome-sass", "~> 6.4"
gem "github-markup",     "~> 4.0", require: "github/markup"
gem "jbuilder",          "~> 2.5"
gem "jquery-rails",      "~> 4.3"
gem "mysql2",            ">= 0.4.4", "< 0.6.0"
gem "puma",              ">= 3.11"
gem "rails",             "~> 6.1.0"
gem "rails-i18n",        "~> 7.0"
gem "sass-rails",        ">= 6"
gem "simple_form",       "~> 5.2"
gem "slim",              ">= 5.1"
gem "turbolinks",        "~> 5"
gem "uglifier",          ">= 1.3.0"
gem 'wicked_pdf',        ">= 2.7"
gem 'wkhtmltopdf-binary',">= 0.12.6.6"

gem "bootsnap", ">= 1.4.2", require: false

group :development, :test do
  gem "letter_opener_web", ">= 2.0"
end

group :development do
  gem "capistrano",           "~> 3.11"
  gem "capistrano-bundler",   "~> 2.1"
  gem "capistrano-passenger", "~> 0.2"
  gem "capistrano-rails",     "~> 1.6"
  gem "capistrano-rvm",       "~> 0.1"
  gem "listen",               ">= 3.8"
  gem "ubpb-rubocop-config",  github: "ubpb/rubocop-config", branch: "main", require: "ubpb/rubocop-config"
  gem "web-console",          ">= 3.3.0"
end
