# frozen_string_literal: true

require './api/message_service/message_service_factory'
require 'logger'

module Notifier
  class Notifier
    LOGGER = Logger.new('logfile.log')
    def initialize
      @publisher = MessageService::MessageServiceFactory.instance.for(:redis)
    end

    def notify(data)
      LOGGER.info('A update was found!')
      LOGGER.info('A message will be send to the tracking channel with the updates')
      @publisher.publish('tracking', data)
    end
  end
end
