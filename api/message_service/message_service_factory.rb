# frozen_string_literal: true

require './api/message_service/publisher/redis'
require 'singleton'

module MessageService
  class MessageServiceFactory
    include Singleton
    MESSAGES_SERVICE = {
      redis: MessageService::Publisher::Redis.new
    }.freeze

    def for(system_cache)
      MESSAGES_SERVICE[system_cache.downcase.to_sym]
    end
  end
end
