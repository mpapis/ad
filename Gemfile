#ruby=1.9.3@ad

source 'https://rubygems.org'

gem 'rails', '~> 3.2'
gem 'sqlite3'
gem 'jquery-rails'
gem 'unicorn'                 # Use unicorn as the app server

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2'
  gem 'coffee-rails', '~> 3.2'
  gem 'uglifier'
end

group :production do
  gem 'therubyracer'
end

group :development do
  gem 'capistrano'
  gem 'capistrano-unicorn'
  gem 'capistrano-file_db'
  gem 'rvm-capistrano', '>=1.3.0.rc4'
end
