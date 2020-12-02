# frozen_string_literal: true

module Notifier
  class Notifier
    def notify(data)
      puts 'A update was found!'
      publisher = MessageService::MessageServiceFactory.instance.for(:redis)
      publisher.publish('tracking', data.to_json)
    end
  end
end
