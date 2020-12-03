# frozen_string_literal: true

require 'simplecov'

SimpleCov.start { add_filter('/test/') }
SimpleCov.minimum_coverage(90)

require 'minitest/autorun'
require 'mocha/minitest'
require 'minitest/unit'
require 'webmock/minitest'
require 'time'
require 'colorize'
require 'minitest/reporters'
require 'rack/test'
require 'byebug'
require './api/routes/api'

Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new)

# class with methods to test.
class Test < Minitest::Test
end

# class with methods to test endpoints.
class TestRoute < Test
  include Rack::Test::Methods

  def app
    TrackingsService::API
  end
end
