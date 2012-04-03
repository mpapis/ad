set :application, "ad"

set :deploy_to, "/home/#{application}/app"
set :user, "#{application}"
set :use_sudo, false
set :scm, :git
set :repository,  "git://github.com/mpapis/ad.git"
set :keep_releases, 5

set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")
set :bundle_without,  [:development]
set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"

server "niczsoft.com", :app, :web, :db, :primary => true

before 'deploy:restart', 'deploy:migrate'
before 'deploy:setup',   'rvm:install_rvm'
before 'deploy:setup',   'rvm:install_ruby'
after  'deploy',         'deploy:cleanup'

require "rvm/capistrano"
require "bundler/capistrano"
require "capistrano-unicorn"
require "capistrano-file_db"
load 'deploy/assets'
