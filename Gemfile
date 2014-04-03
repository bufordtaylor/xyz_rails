source "https://rubygems.org"

gem "rails", "4.0.4"
gem "sass-rails", "~> 4.0.2"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.0.0"
gem "jquery-rails"
gem "turbolinks"
gem "jbuilder", "~> 1.2"

gem "json"
gem "haml"
gem "pg"
gem "passenger"
gem "anjlab-bootstrap-rails", "~> 3.0.0.3", require: "bootstrap-rails"
gem "nprogress-rails"
gem "geocoder"
gem "pg_search"
gem "database_cleaner"

group :test, :development do
  gem "rspec", "~> 3.0.0.beta2"
  gem "rspec-rails", "~> 3.0.0.beta"
  gem "factory_girl_rails", "~> 4.0"

  gem "guard"
  gem "guard-rspec"
  gem "rb-inotify", require: false
  gem "rb-fsevent", require: false
  gem "rb-fchange", require: false
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"

  gem "capistrano"
  gem "rvm-capistrano"
  gem "colored"

  gem "spring"
  gem "spring-commands-rspec"
end


group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem "sdoc", require: false
end

# Use ActiveModel has_secure_password
# gem "bcrypt", "~> 3.1.7"

# Use unicorn as the app server
# gem "unicorn"

# Use Capistrano for deployment
# gem "capistrano", group: :development

# Use debugger
# gem "debugger", group: [:development, :test]