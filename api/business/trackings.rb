# frozen_string_literal: true

require './api/parcels/parcels_factory'
require './api/utils/utils'
require './api/system_cache/cache_factory'

module Business
  # Here must be the business logic of trackings
  class Tracking
    include Utils
    def initialize
      @cache = SystemCache::CacheFactory.instance.for(:redis)
    end

    def create(tracking_number, carrier)
      parcel_service = Parcels::ParcelsFactory.instance.for(carrier)
      tracking_info = parcel_service.track(tracking_number).first
      data = { tracking_number: tracking_number, carrier: carrier.downcase }
      data[:tracking_status] = parcel_service.tracking_status(tracking_info.details[:status_code])
      data[:event_list] = tracking_info.events.map { |event| Utils.event_to_hash(event) }
      # data[:event_list].pop
      @cache.set(tracking_number, data.to_json)
      JSend.success(tracking_information: data)
    rescue Fedex::RateError => e
      JSend.fail(e)
    rescue Redis::CannotConnectError => e
      JSend.error('Cannot connect to Redis')
    rescue StandardError => e
      JSend.error(e)
    end
  end
end
