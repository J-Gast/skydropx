# frozen_string_literal: true

require 'dry-container'
require 'dry-auto_inject'
require 'fedex'
require 'redis'

# Maintains the services in memory or creates them accordingly
class Services
  extend Dry::Container::Mixin

  register :redis, memoize: true do
    Redis.new
  end

  register :fedex, memoize: true do
    fedex = Fedex::Shipment.new(key: 'O21wEWKhdDn2SYyb',
                                password: 'db0SYxXWWh0bgRSN7Ikg9Vunz',
                                account_number: '510087780',
                                meter: '119009727',
                                mode: 'test')
    fedex
  end
end

ServicesContainer = Dry::AutoInject(Services)
