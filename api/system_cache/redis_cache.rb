# frozen_string_literal: true

module SystemCache
  class RedisCache
    def initialize
      @redis = Services[:redis]
    end

    def get(key)
      @redis.get(key)
    end

    def set(key, value)
      @redis.set(key, value)
    end

    def delete(key)
      @redis.del(key)
    end

    def all_keys
      @redis.keys('*')
    end
  end
end
