# frozen_string_literal: true

module MessageService
  module Publisher
    class Redis
      def initialize
        @redis = Services[:redis]
      end

      def publish(channel, message)
        @redis.publish(channel, message)
      end
    end
  end
end

