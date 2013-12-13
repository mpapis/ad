#set :format, :pretty
set :log_level, :debug
set :pty, true

set :application, 'ad'

set :deploy_to, "/home/#{fetch(:application)}/app"
set :keep_releases, 5

set :repo_url, 'git://github.com/mpapis/ad.git'
set :scm, :git

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

#  after :restart, :clear_cache do
#    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
#    end
#  end

  after :finishing, 'deploy:cleanup'

  task :bundle_install do
    on roles(:app) do
      within release_path do
        execute :bundle, "install --quiet --system --without [:test, :development]"
      end
    end
  end
  before 'deploy:symlink:release', 'deploy:bundle_install'

end
namespace :deploy do
  task :env_check do
    on roles(:all) do
      with({ TEST_ME: "something" }) do
        within fetch(:release_path) do
          puts capture(:ruby, "-e 'puts ENV[\"TEST_ME\"]'")
        end
      end
    end
  end
end
before "deploy:env_check", "deploy:updating"
before "deploy:env_check", 'rvm1:hook'
