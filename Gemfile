source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.5.1"

gem "bcrypt",            "~> 3.1.7"
gem "bootstrap",         "~> 4.1"
gem "commonmarker",      "~> 0.17"
gem "font-awesome-sass", "~> 5.0", ">= 5.0.13"
gem "github-markup",     "~> 2.0.1", require: "github/markup"
gem "jbuilder",          "~> 2.5"
gem "jquery-rails",      "~> 4.3"
gem "mysql2",            ">= 0.4.4", "< 0.6.0"
gem "puma",              "~> 3.11"
gem "rails",             "~> 5.2.1"
gem "rails-i18n",        "~> 5.1.1"
gem "sassc",             ">= 1.11"
gem "simple_form",       "~> 4.0.1"
gem "slim",              "~> 3.0"
gem "turbolinks",        "~> 5"
gem "uglifier",          ">= 1.3.0"

# For pending axlsx release we pin the latest 3.0.0 pre-release to fix a ruby-zip vuln.
gem "rubyzip",     ">= 1.2.1"
gem "axlsx",       "3.0.0.pre" #git: "https://github.com/randym/axlsx.git", ref: "c8ac844"
gem "axlsx_rails", "0.5.2"

gem "bootsnap", ">= 1.1.0", require: false

group :development, :test do
  gem "pry-byebug", "~> 3.6", platform: :mri
  gem "pry-rails",  "~> 0.3", platform: :mri
end

group :development do
  gem "capistrano",           "~> 3.11"
  gem "capistrano-bundler",   "~> 1.3.0"
  gem "capistrano-passenger", "~> 0.2.0"
  gem "capistrano-rails",     "~> 1.4.0"
  gem "capistrano-rvm",       "~> 0.1.2"
  gem "letter_opener_web",    "~> 1.3"
  gem "listen",               ">= 3.0.5", "< 3.2"
  gem "web-console",          "~> 3.5"
end
