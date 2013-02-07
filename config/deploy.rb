require "bundler/capistrano"
require "whenever/capistrano"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :application, "Erobot"
set :repository,  "git@github.com:sanojimaru/Erobot.git"
set :scm, :git
set :user, "www"
set :branch, "develop"
set :deploy_to,  "/var/www/#{application}"
set :use_sudo, false
set :whenever_roles, "app"
set :whenever_command, "bundle exec whenever"

role :web, "capistrano_rails.gameraworks.com"
role :app, "capistrano_rails.gameraworks.com"
role :db,  "capistrano_rails.gameraworks.com", primary: true

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
