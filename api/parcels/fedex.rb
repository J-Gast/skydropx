# frozen_string_literal: true

require './api/tasks/services'

module Parcels
  class Fedex
    def initialize
      @fedex = Services[:fedex]
    end

    def track(tracking_number)
      @fedex.track(tracking_number: tracking_number)
    end
  end
end
