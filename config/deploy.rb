$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
require "bundler/capistrano"
set :rvm_ruby_string, '1.9.3@ad'
set :rvm_type, :user

set :application, "ad"

set :scm, :git
set :repository,  "git://github.com/mpapis/ad.git"

set :user, "ad"
set :use_sudo, false
set :deploy_to, "/home/#{application}/app"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

server "niczsoft.com", :app, :web, :db, :primary => true

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true} do
    run "unicorn_rails -c #{deploy_to}/current/config/unicorn.rb -D -E production"
  end

  task :stop, :roles => :app, :except => { :no_release => true} do
    run "kill `cat #{unicorn_pid}`"
  end

  task :reload, :roles => :app, :except => { :no_release => true } do
    run "kill -s USR2 `cat #{unicorn_pid}`"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
end
