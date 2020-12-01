# frozen_string_literal: true

require './api/parcels/parcels_factory'
require './api/utils/utils'
require './api/tasks/services'
require './api/system_cache/cache_factory'

module Tasks
  class Updater
    def self.look_for_updates
      Thread.new do
        cache = SystemCache::CacheFactory.instance.for(:redis)
        loop do
          keys = cache.all_keys
          p keys
          keys.each do |tracking_number|
            stored_events = JSON.parse(cache.get(tracking_number))
            carrier = JSON.parse(stored_events.first)['carrier']
            parcel_service = Parcels::ParcelsFactory.instance.for(carrier)
            tracking_info = parcel_service.track(tracking_number).first
            event_list = tracking_info.events.map { |event| Utils.event_to_hash(event) }
            Updater.notify(cache, event_list) if Updater.updates_found?(stored_events, event_list)
          end
          sleep 5
        end
      end
    end

    def self.updates_found?(stored_events, current_events)
      return false if stored_events.size == current_events.size

      true
    end

    def self.notify(redis, data)
      puts 'A update was found!'
      redis.publish('tracking', data)
    end
  end
end
