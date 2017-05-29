source 'https://rubygems.org'
ruby '2.3.3'
gem 'rails', '4.2.7.1'

gem 'puma'
gem 'aws-sdk', '< 2.0' # if ENV['storage'] == "s3"
gem 'figaro'
gem 'devise'

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'simple_form'
gem "paperclip", "~> 4.3"
gem 'nokogiri'
gem 'sprockets', '3.6.3'

group :development do
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'better_errors'
  gem "binding_of_caller"
  gem 'quiet_assets'
  gem 'rails_layout'
  gem 'spring-commands-rspec'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'rspec-rails'
  gem 'sqlite3'
end

group :production do
  gem 'rails_12factor'
  gem 'mysql2'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'poltergeist'
end
