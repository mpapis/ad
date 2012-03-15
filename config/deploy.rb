set :application, "ad"

set :deploy_to, "/home/#{application}/app"
set :user, "#{application}"
set :use_sudo, false
set :scm, :git
set :repository,  "git://github.com/mpapis/ad.git"

set :rvm_ruby_string, :release_path
set :rvm_type, :user
set :bundle_without,  [:development]
set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"

server "niczsoft.com", :app, :web, :db, :primary => true

before 'deploy:restart', 'deploy:migrate'

$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
require "bundler/capistrano"
require "capistrano-unicorn"
require "capistrano-file_db"
load 'deploy/assets'
