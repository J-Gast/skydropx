# frozen_string_literal: true

require './api/parcels/parcels_factory'
require './api/utils/utils'
require './api/system_cache/cache_factory'

module Business
  # Here must be the business logic of trackings
  class Tracking
    def initialize
      @cache = SystemCache::CacheFactory.instance.for(:redis)
    end

    def create(tracking_number, carrier)
      parcel_service = Parcels::ParcelsFactory.instance.for(carrier)
      tracking_info = parcel_service.track(tracking_number).first
      event_list = tracking_info.events.map do |event|
        hash = Utils.event_to_hash(event)
        hash[:carrier] = carrier.downcase
        hash.to_json
      end
      # event_list.pop
      @cache.set(tracking_number, event_list)
      event_list
    end
  end
end
