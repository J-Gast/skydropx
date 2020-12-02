# frozen_string_literal: true

require './api/parcels/parcels_factory'
require './api/utils/utils'
require './api/tasks/services'
require './api/system_cache/cache_factory'
require './api/message_service/message_service_factory'
require './notifier/notifier'

module Updater
  class Updater
    def initialize
      @cache = SystemCache::CacheFactory.instance.for(:redis)
      @notifier = Notifier::Notifier.new
    end

    def look_for_updates
      Thread.new do
        loop do
          begin
          keys = @cache.all_keys
          p keys
          keys.each { |tracking_number| update_tracking_information(tracking_number) }
          sleep 5
          rescue StandardError => e
            sleep 10
          end
        end
      end
    end

    def updates_found?(stored_events, current_events)
      return false if stored_events.size == current_events.size

      true
    end

    def update_tracking_information(tracking_number)
      stored_info = JSON.parse(cache.get(tracking_number))
      stored_events = stored_info['event_list']
      parcel_service = Parcels::ParcelsFactory.instance.for(stored_info['carrier'])
      tracking_info = parcel_service.track(tracking_number).first
      event_list = tracking_info.events.map { |event| Utils.event_to_hash(event) }
      tracking_status = parcel_service.tracking_status(tracking_info.details[:status_code])
      if updates_found?(stored_events, event_list)
        stored_info['tracking_status'] = tracking_status
        stored_info['event_list'] = event_list
        updated_info = stored_info.to_json
        @notifier.notify(updated_info)
        @cache.set(tracking_number, updated_info)
      end
      @cache.delete(tracking_number) if tracking_status == :DELIVERED
    end
  end
end
