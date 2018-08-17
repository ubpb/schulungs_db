lock "~> 3.11.0"

set :application, "schulungsdb"
set :repo_url, "git@github.com:ubpb/schulungs_db.git"
set :branch, "master"
set :log_level, :debug

append :linked_files, "config/database.yml"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

set :rvm_type, :user
set :rvm_ruby_version, "default"
set :rails_env, "production"
