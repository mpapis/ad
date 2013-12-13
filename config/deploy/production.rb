set :stage, :production

server 'niczsoft.com', user: fetch(:application), roles: %w{web app}
