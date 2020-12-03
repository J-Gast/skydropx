# frozen_string_literal: true

source 'http://rubygems.org' do
  gem 'dry-auto_inject',        '~> 0.4'
  gem 'dry-container',          '~> 0.6'
  gem 'fedex'
  gem 'grape',                  '~> 1.2'
  gem 'grape-entity'
  gem 'json',                   '~> 2.2'
  gem 'puma',                   '~> 4.0'
  gem 'rake',                   '~> 12.3'
  gem 'redis'

  group :development, :test do
    gem 'byebug'
    gem 'pry'
  end

  group :development do
    gem 'rubocop'
  end

  group :test do
    gem 'colorize', '~> 0.8'
    gem 'grape-swagger'
    gem 'grape-swagger-entity'
    gem 'minitest',             '~> 5.11'
    gem 'minitest-reporters',   '~> 1.3'
    gem 'mocha',                '1.5.0'
    gem 'rack-test',            '~> 1.1'
    gem 'simplecov', require: false
    gem 'webmock', '~> 3.0'
  end
end
