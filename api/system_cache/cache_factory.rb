# frozen_string_literal: true

require './api/system_cache/redis_cache'
require 'singleton'

module SystemCache
  class CacheFactory
    include Singleton
    SYSTEMS_CACHE = {
      redis: SystemCache::RedisCache.new
    }.freeze

    def for(system_cache)
      SYSTEMS_CACHE[system_cache.downcase.to_sym]
    end
  end
end
