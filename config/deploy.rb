require "bundler/capistrano"
require "fast_git_deploy/enable"

set :application, "testviet"
set :repository, "git@github.com:dangluan/testviet.git"

set :user, 'vagrant'
set :use_sudo, false
set :deploy_type, :deploy
set :branch, 'master'

default_run_options[:pty] = true
ssh_option[:forward_agent] = true
ssh_option[:keys] = [File.join(ENV["HOME"], '.vagrant.d', 'insecure_private_key')]

role :app, "testviet.vn"
role :web, "testviet.vn"
role :db, "testviet.vn"

after "deploy:setup" do
  deploy.fast_git_setup.clone_repository
  run "cd #{current_path} && bundle install"
end

namespace :unicorn do
  desc "start unicorn"
  task :start do
    run "cd #{current_path} && bundle exec unicorn -c /etc/unicorn/testviet.conf.rb -D"
  end
end

namespace :deploy do
  task :create_symlink do; end
end