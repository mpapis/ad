set :rvm_require_role, :app
require "rvm/capistrano"
require "bundler/capistrano"
require "capistrano-unicorn"
require "capistrano-file_db"
load 'deploy/assets'

set :application, "ad"

set :deploy_to, "/home/#{application}/app"
set :user, "#{application}"
set :use_sudo, false
set :scm, :git
set :repository,  "git://github.com/mpapis/ad.git"
set :keep_releases, 5

set :rvm_autolibs_flag, "read-only" # more info: rvm help autolibs
set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")
set :bundle_dir, ''
set :bundle_flags, '--system --quiet'
set :bundle_without,  [:development]
set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"

server "niczsoft.com", :app, :web, :db, :primary => true

before 'deploy:restart', 'deploy:migrate'
# Install RVM
before 'deploy',         'rvm:install_rvm'
# Install Ruby
before 'deploy',         'rvm:install_ruby'
# Or create gemset
#before 'deploy',         'rvm:create_gemset'
after  'deploy',         'deploy:cleanup'
