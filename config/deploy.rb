set :application, "ad"

set :deploy_to, "/home/#{application}/app"
set :user, "#{application}"
set :use_sudo, false
set :scm, :git
set :repository,  "git://github.com/mpapis/ad.git"

set :rvm_ruby_string, '1.9.3@ad'
set :rvm_type, :user
set :bundle_without,  [:assets, :development]

server "niczsoft.com", :app, :web, :db, :primary => true

$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
require "bundler/capistrano"
require "capistrano-unicorn"

before 'deploy:restart', 'deploy:migrate'