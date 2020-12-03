# frozen_string_literal: true

require 'dry-container'
require 'dry-auto_inject'
require 'fedex'
require 'redis'
require 'yaml'
require './api/tasks/service_config'

# Maintains the services in memory or creates them accordingly
class Services
  extend Dry::Container::Mixin

  register :redis, memoize: true do
    Redis.new
  end

  register :fedex, memoize: true do
    Fedex::Shipment.new(ServiceConfig[:configuration]['fedex'].symbolize_keys)
  end
end

ServicesContainer = Dry::AutoInject(Services)
