#ruby=2.0.0@ad

source 'https://rubygems.org'

gem 'rails', '~> 4.2'
gem 'sqlite3'
gem 'jquery-rails'
gem 'unicorn'                 # Use unicorn as the app server

gem 'devise', '~> 3.4'
# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'bootstrap-sass', '~> 3.3.5'
  gem 'sass-rails', '~> 5.0'
  gem 'coffee-rails', '~> 4.1'
  gem 'uglifier'
end

group :production do
  gem 'therubyracer'
end

group :development do
  gem 'command-designer', :require => false
  gem 'remote-exec', :require => false
end
