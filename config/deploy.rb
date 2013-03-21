load "deploy/assets"
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

set :domain, "capistrano_rails.gameraworks.com"

role :web, domain
role :app, domain
role :db,  domain, primary: true

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :seed do
    run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end

  task :create_directory do
    run <<-CMD
      mkdir -p #{shared_path}/sockets
    CMD
  end

  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      from = source.next_revision(current_revision)
      if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ lib/assets/ | wc -l").to_i > 0
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end
end

require "capistrano-unicorn"
after 'deploy:restart', 'unicorn:reload'
after 'deploy:create_symlink', 'deploy:create_directory'
