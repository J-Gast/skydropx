# frozen_string_literal: true

require './api/tasks/services'

module Parcels
  class Fedex
    TRACKING_STATUS = {
      OC: :CREATED,
      AP: :CREATED,
      AR: :ON_TRANSIT,
      CC: :ON_TRANSIT,
      DP: :ON_TRANSIT,
      FD: :ON_TRANSIT,
      HL: :ON_TRANSIT,
      IT: :ON_TRANSIT,
      OD: :ON_TRANSIT,
      PU: :ON_TRANSIT,
      SF: :ON_TRANSIT,
      CA: :DELIVERED,
      DL: :DELIVERED,
      CD: :EXCEPTION,
      DE: :EXCEPTION,
      SE: :EXCEPTION
    }.freeze

    def initialize
      @fedex = Services[:fedex]
    end

    def track(tracking_number)
      @fedex.track(tracking_number: tracking_number)
    end

    def tracking_status(carrier_status)
      TRACKING_STATUS[carrier_status.to_sym]
    end
  end
end
