source "http://rubygems.org"
# Add dependencies required to use your gem here.
# Example:
gem 'arel', '~> 2.0'
gem 'activerecord', '~> 3.0'

case ENV["RAILS_DB"]
when "postgres"
  gem 'pg'
when "mysql"
  gem 'mysql2', '~>0.2.11'
else
  gem 'sqlite3'
end

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development do
  gem "bundler", ">= 1.0.0"
  gem "jeweler", ">= 1.5.2"
  gem "rcov", ">= 0"
end

group :test do
  gem 'redgreen'
  gem 'turn'
  gem 'rake', '~>0.8.3'
end

